#///// ================================== medir_error.c ============================================= /////
#///// ======================================================================================================== /////
#///// Scipt que utiliza el programa medir_error.c para calcular el lockin con la FPGA en distintas N /////
#///// ======================================================================================================== /////
/*
    Debe ejecutarse en el micro de la FPGA, con la sintaxis:
        -> medir_error N f n_iteraciones fuente nombre_archivo_salida
        
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
#include <unistd.h>

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

double calcular_media(const Array *arr);
double calcular_desviacion_estandar(const Array *arr);
double convertir_a_volt(double valor);

int main(int argc, char *argv[]) {
    int fd;
    void *cfg;
    char *name = "/dev/mem";

    ///// ================================================================================= /////
    ///// ============================ Seteo de parámetros ================================ /////
    ///// ================================================================================= /////

    /*  Cosas a setear
        f_dac_real=set_frec_dac(cfg,frec_dac);          SI
        f_ref_real=set_frec_ref(cfg,frec_ref);          SI
        setM(cfg,M);                                    SI
        setN_ma(cfg,N_ma);                              SI
        setDecimator(cfg,decimator);
        setDataSelection(cfg,sel);
        setDecimatorMethod(cfg,decimator_method);
    
    */

    // Verificar que se proporcionen los argumentos necesarios
    if ((argc != 6)) {
        printf("medir_error N frecuencia n_iteraciones fuente nombre_archivo_salida\n");
        return 1;
    }

    ///// ========================== Parametros  ===================================== /////    
    int N = atoi(argv[1]);
    int f = atoi(argv[2]);
    int f_dac = atoi(argv[2]);  // 0 -> Para moverlo junto con la frecuencia del barrido!
    int n_iteraciones = atoi(argv[3]);
    int fuente = atoi(argv[4]);
    char *nombre_archivo_salida = argv[5];

    
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

    // Ciclos de decimacion -> Es lo mismo para este script pero si no lo seteas falla!
    setDecimator(cfg,1);
    setDecimatorMethod(cfg,0);

    // Ciclos de integración    
    setN_ma(cfg, N);

    double f_real_dac = set_frec_dac(cfg, f_dac);
    double f_real_ref = set_frec_ref(cfg, f);    

    // Puntos por ciclo    
    int M = 125000000 / f;
    setM(cfg, M);    
    

    ///// ================================================================================= /////
    ///// ============================ Calculos =========================================== /////
    ///// ================================================================================= /////

    Array r_values, phi_values;
    init_array(&r_values, 100);
    init_array(&phi_values, 100);

    for (int i = 0; i < n_iteraciones; i++) {        

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
        
        double r_en_volt = convertir_a_volt(r);

        append_array(&r_values, r_en_volt);
        append_array(&phi_values, phi);

        ResetFPGA(cfg);
    }

    ///// ================================================================================= /////
    ///// ============================ Archivo salida ===================================== /////
    ///// ================================================================================= /////

    // Abre el archivo de salida para escritura
    FILE *archivo_salida = fopen(nombre_archivo_salida, "a");
    if (archivo_salida == NULL) {
        fprintf(stderr, "Error al abrir el archivo de salida.\n");
        return 1;
    }

    //N frecuencia n_iteraciones fuente nombre_archivo_salida

    // Escribe los valores de mean r y std r en el archivo de salida
    fprintf(archivo_salida, "\nMedidas de error -> f: %f, N: %d, n_iteraciones: %d, fuente: %d \nConstante de tiempo[us]: %f", f_real_dac, N, n_iteraciones, fuente, (double)N/f*1000000);

    double media = calcular_media(&r_values) * 1000;
    double desviacion = calcular_desviacion_estandar(&r_values) * 1000;

    printf("Media: %f\n", media);
    printf("Desviación estándar: %f\n", desviacion);

    fprintf(archivo_salida, "\nMedia[mV]: %f \nDesviacion estandar[mV]: %lf \n", media,desviacion);


    // Cierra el archivo de salida
    fclose(archivo_salida);

    // Liberar la memoria de los arrays
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


// Función para calcular la media
double calcular_media(const Array *arr) {
    double suma = 0.0;
    for (size_t i = 0; i < arr->size; i++) {
        suma += arr->data[i];
    }
    return arr->size > 0 ? suma / arr->size : 0.0;
}

// Función para calcular la desviación estándar
double calcular_desviacion_estandar(const Array *arr) {
    double media = calcular_media(arr);
    double suma_diferencias_cuadradas = 0.0;
    for (size_t i = 0; i < arr->size; i++) {
        double diferencia = arr->data[i] - media;
        suma_diferencias_cuadradas += diferencia * diferencia;
    }
    return arr->size > 0 ? sqrt(suma_diferencias_cuadradas / arr->size) : 0.0;
}

double convertir_a_volt(double valor){
    double medido = (valor)/8192;
    double correccion = 508.0/478; //Medido empiricamente
    double volt = (medido*correccion);
    return volt;
}
