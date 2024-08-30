#///// ================================== barrido_en_frecuencia.c ============================================= /////
#///// ======================================================================================================== /////
#///// Scipt que utiliza el programa barrido_en_frecuencia.c para calcular el lockin con la FPGA en distintas N /////
#///// ======================================================================================================== /////
/*
    Debe ejecutarse en el micro de la FPGA, con la sintaxis:
        -> barrido_en_frecuencia N f_inicial f_final f_step fuente nombre_archivo_salida
        
*/

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
    if ((argc != 8)) {
        printf("Uso barrido_en_frecuencia N f_inicial f_final f_step f_dac fuente nombre_archivo_salida\n");
        return 1;
    }

    ///// ========================== Parametros  ===================================== /////    
    int N = atoi(argv[1]);
    int f_inicial = atoi(argv[2]);
    int f_final = atoi(argv[3]);
    int f_step = atoi(argv[4]);
    int f_dac = atoi(argv[5]);  // 0 -> Para moverlo junto con la frecuencia del barrido!
    int fuente = atoi(argv[6]);
    char *nombre_archivo_salida = argv[7];

    
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
    
    // Fuente de los datos: --> { SIM = 0, ADC = 1 };
    setDataSelection(cfg, fuente);



    // Ciclos de integración    
    setN_ma(cfg, N);

    double f_real_dac;
    if(f_dac != 0)
    {
        f_real_dac = set_frec_dac(cfg, f_dac);
    }
    

    ///// ================================================================================= /////
    ///// ============================ Calculos =========================================== /////
    ///// ================================================================================= /////

    Array f_values, r_values, phi_values;
    init_array(&f_values, 100);
    init_array(&r_values, 100);
    init_array(&phi_values, 100);

    for (int f = f_inicial; f < f_final; f=f+f_step) {

        // Frecuencias de operacion (referencias dac y clock)
        double f_real_ref = set_frec_ref(cfg, f);

         if(f_dac == 0)
    {
        f_real_dac = set_frec_dac(cfg, f_real_ref);
    }
        

        int M = 125000000 / f;

        // Puntos por ciclo    
        setM(cfg, M);
        
        printf("Calculando f: %d\n", f);

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
        
        append_array(&f_values, f);
        append_array(&r_values, r);
        append_array(&phi_values, phi);

        ResetFPGA(cfg);
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
    fprintf(archivo_salida, "Barrido en frecuencia -> f_inicial:%d, f_final:%d, f_step:%d\n", f_inicial, f_final, f_step);
    fprintf(archivo_salida, "Parametros -> N: %d, Fuente: %d, F_dac:%f \n", N, fuente,f_real_dac);
    fprintf(archivo_salida, "Formato -> f,r,phi\n\n");

    for (size_t i = 0; i < r_values.size; i++) {
        fprintf(archivo_salida, "%.12f,%.12f,%.12f\n", f_values.data[i], r_values.data[i], phi_values.data[i]);
    }

    // Cierra el archivo de salida
    fclose(archivo_salida);

    // Liberar la memoria de los arrays
    free_array(&f_values);
    free_array(&r_values);
    free_array(&phi_values);

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

