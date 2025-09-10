/***************************************************************************************
 *  barrido_ctes_tiempo.c
 *
 *  Programa en C para ejecutar en el micro de la FPGA. 
 *  Realiza cálculos de lock-in promediando N ciclos coherentes y estima el ruido 
 *  mediante varias iteraciones. Los resultados se guardan en un archivo CSV.
 *
 *  ------------------------------------------------------------------------------------
 *  Uso:
 *      barrido_ctes_tiempo frec N_inicial N_final iteraciones fuente archivo_salida
 *
 *  Parámetros:
 *      frec            -> Frecuencia de referencia (Hz)
 *      N_inicial       -> Valor inicial de N
 *      N_final         -> Valor final de N (no inclusivo en el bucle)
 *      iteraciones     -> Cantidad de repeticiones por cada N
 *      fuente          -> 0 = datos simulados, 1 = datos del ADC
 *      archivo_salida  -> Nombre del archivo CSV donde se guardan los resultados
 *
 *  ------------------------------------------------------------------------------------
 *  Descripción:
 *   - Configura la FPGA vía /dev/mem (registros de control y datos).
 *   - Barre valores de N entre N_inicial y N_final-1.
 *   - Para cada N:
 *        * Repite 'iteraciones' mediciones del lock-in.
 *        * Calcula amplitud (r) y fase (phi).
 *        * Estima media y desviación estándar de r.
 *   - Escribe en archivo CSV: N, mean_r, std_r.
 *
 *  ------------------------------------------------------------------------------------
 *  Notas:
 *   - Requiere permisos de root para acceso a /dev/mem.
 *   - Si getFinish() nunca se activa, el programa puede bloquearse indefinidamente.
 *   - Frecuencia real configurada puede diferir levemente de la solicitada.
 *
 ***************************************************************************************/


#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <unistd.h>
#include <math.h>
#include <string.h>
#include <stdint.h>

#define START_ADDRESS 0x40000000
#define ENABLE_ADDRESS 0x41230000
#define RESET_ADDRESS 0x41230008

#define FINISH_ADDRESS 0x41210000
#define RESULT_FASE_LOW_ADDRESS 0x41200000
#define RESULT_FASE_HIGH_ADDRESS 0x41200008
#define RESULT_CUAD_LOW_ADDRESS 0x41220000
#define RESULT_CUAD_HIGH_ADDRESS 0x41220008

#define FIFO_1_ADDRESS 0x43c00000

#define M_ADDRESS 0x41240000
#define N_ADDRESS 0x41240008
#define DECIMATOR_ADDRESS 0x41250000
#define DECIMATOR_METHOD_ADDRESS 0x41210008
#define SELECT_DATA_ADDRESS 0x41250008
#define N_DATOS_PROMEDIADOS_ADDRESS 0x41270000

#define PHASE_DAC_ADDRESS 0x41260000
#define PHASE_REF_ADDRESS 0x41260008

void ResetFPGA(void *cfg);
void setEnable(void *cfg);
void ClearEnable(void *cfg);

void setN_ma(void *cfg, uint32_t N_ma);
void setM(void *cfg, uint32_t M);
void setDecimator(void *cfg, uint32_t dec);
void setDataSelection(void *cfg, uint32_t sel);
double set_frec_dac(void *cfg, double frec);
double set_frec_ref(void *cfg, double frec);
void setDecimatorMethod(void *cfg, uint32_t dec_method);
uint32_t get_datos_promediados(void *cfg);

uint32_t getFinish(void *cfg);
uint32_t get_fase_low(void *cfg);
uint32_t get_fase_high(void *cfg);
uint32_t get_cuad_low(void *cfg);
uint32_t get_cuad_high(void *cfg);

int32_t* leerFIFO(void *cfg, int fifo_address);

void escribirArchivo_li(const char* nombreArchivo, double f, double M, double N, double r, double phi);
void escribirArchivo_adc(const char* nombreArchivo, int32_t* valores);


// Definir estructuras para almacenar f, r y phi.
typedef struct {
    double *data;
    size_t size;
    size_t capacity;
} Array;

void init_array(Array *a, size_t initial_capacity) {
    a->data = (double *)malloc(initial_capacity * sizeof(double));
    a->size = 0;
    a->capacity = initial_capacity;
}

void append_array(Array *a, double value) {
    if (a->size == a->capacity) {
        a->capacity *= 2;
        a->data = (double *)realloc(a->data, a->capacity * sizeof(double));
    }
    a->data[a->size++] = value;
}

void free_array(Array *a) {
    free(a->data);
}

int main(int argc, char *argv[]) {
    int fd;
    void *cfg;
    char *name = "/dev/mem";

    ///// ================================================================================= /////
    ///// ============================ Seteo de parámetros ================================ /////
    ///// ================================================================================= /////

    // Verificar que se proporcionen los argumentos necesarios
    if ((argc != 7)) {
        printf("Uso barrido_cte_tiempo frec N_inicial N_final iteraciones fuente nombre_archivo_salida\n");
        return 1;
    }

    ///// ========================== Parametros  ===================================== /////    
    int frec = atoi(argv[1]);
    int N_inicial = atoi(argv[2]);
    int N_final = atoi(argv[3]);
    int iteraciones = atoi(argv[4]);
    int fuente = atoi(argv[5]);
    char *nombre_archivo_salida = argv[6];

    int M = 125000000 / frec;

    ///// ========== Mapeo el espacio de memoria de la FPGA al puntero cfg ============ /////    
    if ((fd = open(name, O_RDWR)) < 0) {
        perror("open");
        return 1;
    }

    cfg = mmap(NULL, 0x4000000, PROT_READ | PROT_WRITE, MAP_SHARED, fd, START_ADDRESS);

    ///// ================================================================================= /////
    ///// ============================ Configuracion ====================================== /////
    ///// ================================================================================= /////

    printf("Iniciando configuracion... \n");

    // Frecuencias de operacion (referencias dac y clock)
    double f_real_ref = set_frec_ref(cfg, frec);
    double f_real_dac = set_frec_dac(cfg, frec);

    // Fuente de los datos: --> { SIM = 0, ADC = 1 };
    setDataSelection(cfg, fuente);

    // Puntos por ciclo    
    setM(cfg, M);

    ///// ================================================================================= /////
    ///// ============================ Calculos =========================================== /////
    ///// ================================================================================= /////

    Array N_values, mean_r_values, std_r_values;
    init_array(&N_values, 10);
    init_array(&mean_r_values, 10);
    init_array(&std_r_values, 10);

    for (int i = N_inicial; i < N_final; i++) {
        printf("Calculando N: %d\n", i);

        // Ciclos de promediacion LI
        setN_ma(cfg, i);

        Array r_values;
        init_array(&r_values, 10);

        for (int j = 0; j < iteraciones; j++) {
            ResetFPGA(cfg);
            setEnable(cfg);

            // Espero a la señal de finalización
            while (getFinish(cfg) == 0) {}

            int64_t resultado_fase, resultado_cuadratura;
            uint32_t res_up = get_fase_high(cfg);
            uint32_t res_low = get_fase_low(cfg);
            resultado_fase = ((uint64_t)res_up << 32) | (uint64_t)res_low;

            res_up = get_cuad_high(cfg);
            res_low = get_cuad_low(cfg);
            resultado_cuadratura = ((uint64_t)res_up << 32) | (uint64_t)res_low;

            int MxN_real = get_datos_promediados(cfg);

            double amplitud_ref = 16384;
            double x = (double)resultado_fase / (MxN_real);
            double y = (double)resultado_cuadratura / (MxN_real);

            double r = (sqrt(x * x + y * y)) * 2 / amplitud_ref;
            double phi = atan2(y, x) * 180 / M_PI;

            append_array(&r_values, r);

            ResetFPGA(cfg);
        }

        // Calcular la media
        double sum = 0.0;
        for (size_t k = 0; k < r_values.size; k++) {
            sum += r_values.data[k];
        }
        double mean = sum / r_values.size;

        // Calcular la desviación estándar
        double variance = 0.0;
        for (size_t k = 0; k < r_values.size; k++) {
            variance += (r_values.data[k] - mean) * (r_values.data[k] - mean);
        }
        double stdev = sqrt(variance / r_values.size);

        append_array(&N_values, i);
        append_array(&mean_r_values, mean);
        append_array(&std_r_values, stdev);

        free_array(&r_values);
    }

    ///// ================================================================================= /////
    ///// ============================ Archivo salida ===================================== /////
    ///// ================================================================================= /////

    // Abre el archivo de salida para escritura
    FILE *archivo_salida = fopen(nombre_archivo_salida, "w");
    if (archivo_salida == NULL) {
        fprintf(stderr, "Error al abrir el archivo de salida.\n");
        return 1;
    }

    // Escribe los valores de mean r y std r en el archivo de salida
    fprintf(archivo_salida, "Barrido de ctes de tiempo -> N_inicial:%d, N_final:%d\n", N_inicial, N_final);
    fprintf(archivo_salida, "Parametros -> f: %.12f, Fuente: %d, Iteraciones: %d\n", f_real_ref, fuente, iteraciones);
    fprintf(archivo_salida, "Formato -> N,mean_r,std_r\n\n");

    for (size_t i = 0; i < mean_r_values.size; i++) {
        fprintf(archivo_salida, "%.12f,%.12f,%.12f\n", N_values.data[i], mean_r_values.data[i], std_r_values.data[i]);
    }

    // Cierra el archivo de salida
    fclose(archivo_salida);

    // Liberar la memoria de los arrays
    free_array(&N_values);
    free_array(&mean_r_values);
    free_array(&std_r_values);

    return 0;
}









// Reset activo en bajo
void ResetFPGA(void *cfg)
{
	// Reseteo la cosa
	*(uint32_t *)(cfg+ ENABLE_ADDRESS - START_ADDRESS ) = 0;
	*(uint32_t *)(cfg+ RESET_ADDRESS - START_ADDRESS ) = 0;
	*(uint32_t *)(cfg+ RESET_ADDRESS - START_ADDRESS ) = 1;
	
}

void setEnable(void *cfg)
{
	// Seteo el enable (o trigger)
	*(uint32_t *)(cfg+ ENABLE_ADDRESS - START_ADDRESS ) = 1;		
	
}

void ClearEnable(void *cfg)
{
	// Seteo el enable (o trigger)
	*(uint32_t *)(cfg+ ENABLE_ADDRESS - START_ADDRESS ) = 0;		
	
}

void setN_ma(void *cfg,uint32_t N_ma)
{
	// Seteo la cantidad de muestras que quiero promediar coherentemente 
	*(uint32_t *)(cfg+ N_ADDRESS - START_ADDRESS) = N_ma ;
}

void setM(void *cfg, uint32_t M)
{
	// Seteo la cantidad de muestras por ciclo de señal 
	*(uint32_t *)(cfg+ M_ADDRESS - START_ADDRESS) = M ;

}

double set_frec_dac(void *cfg, double frec)
{
	// Seteo la cantidad de muestras por ciclo de señal
	int32_t phase = 2.1474 * frec; 
	*(uint32_t *)(cfg+ PHASE_DAC_ADDRESS - START_ADDRESS) = phase ;
	return (double)phase*125000000/(pow(2,28));

}

double set_frec_ref(void *cfg, double frec)
{
	// Seteo la cantidad de muestras por ciclo de señal
	int32_t phase = 2.1474 * frec; 
	*(uint32_t *)(cfg+ PHASE_REF_ADDRESS - START_ADDRESS) = phase ;
	return (double)phase*125000000/(pow(2,28));
}


void setDecimator(void *cfg,uint32_t dec)
{

	*(uint32_t *)(cfg+ DECIMATOR_ADDRESS - START_ADDRESS) = dec ;
}

void setDecimatorMethod(void *cfg,uint32_t dec_method)
{

	*(uint32_t *)(cfg+ DECIMATOR_METHOD_ADDRESS - START_ADDRESS) = dec_method ;
}

void setDataSelection(void *cfg,uint32_t sel)
{

	*(uint32_t *)(cfg+ SELECT_DATA_ADDRESS - START_ADDRESS) = sel ;
}

uint32_t getFinish(void *cfg)
{
	return *((uint32_t *)(cfg+ FINISH_ADDRESS - START_ADDRESS) );
}

uint32_t get_fase_low(void *cfg)
{
	return *((uint32_t *)(cfg+ RESULT_FASE_LOW_ADDRESS - START_ADDRESS) );
}

uint32_t get_fase_high(void *cfg)
{
	return *((uint32_t *)(cfg+ RESULT_FASE_HIGH_ADDRESS - START_ADDRESS) );
}

uint32_t get_cuad_low(void *cfg)
{
	return *((uint32_t *)(cfg+ RESULT_CUAD_LOW_ADDRESS - START_ADDRESS) );
}

uint32_t get_cuad_high(void *cfg)
{
	return *((uint32_t *)(cfg+ RESULT_CUAD_HIGH_ADDRESS - START_ADDRESS) );
}

uint32_t get_datos_promediados(void *cfg)
{
	return *((uint32_t *)(cfg+ N_DATOS_PROMEDIADOS_ADDRESS - START_ADDRESS) );
}


// Funciones para leer los FIFO.. esta los toma como FIFOS independientes
int32_t* leerFIFO(void *cfg,int fifo_address)
{
	int i = 0;
	int32_t * data ;
	data = (int32_t *)malloc(514 * sizeof(int32_t));
	for (i=0;i<514;i++)
	{	
		int32_t read = *((int32_t *)(cfg+ fifo_address - START_ADDRESS + 0x20) );
		*(data+i) = read;
		
	}
	return data;
}


void escribirArchivo_li(const char* nombreArchivo, double f, double M, double N, double r, double phi) {
    FILE *archivo;
    archivo = fopen(nombreArchivo, "w");
    if (archivo == NULL) {
        printf("Error al abrir el archivo.");
        return;
    }

    fprintf(archivo, "Resultados: f,M,N,r,phi\n");
    fprintf(archivo, "%f,%f,%f,%f,%f\n", f, M, N, r, phi);

    fclose(archivo);
}

void escribirArchivo_adc(const char* nombreArchivo, int32_t* valores){
	FILE *archivo;
    archivo = fopen(nombreArchivo, "w");
    if (archivo == NULL) {
        printf("Error al abrir el archivo.");
        return;
    }

	fprintf(archivo, "Valores del ADC: \n\n");

	for(int i = 0; i<512;i++)
	{
		if(i!=511){
			fprintf(archivo, "%d, ", *(valores+i));
		}else{
			fprintf(archivo, "%d", *(valores+i));
		}
		

	}

}

