

///// ========================== LOCKIN.C ============================= /////
///// ===================================================================== /////
///// Programa en c para setear los parametros de la FPGA y obtener medidas /////
///// ===================================================================== /////
/*
	Debe ejecutarse en el micro de la FPGA, con la sintaxis:
		-> lockin N_ma | M 
	
	La frecuencia de muestreo va a quedar 125MHz / K_sobremuestreo
*/


#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <stdlib.h>
#include "string.h"
#include <time.h>
#include <math.h>

#define START_ADDRESS 0x40000000
#define ENABLE_ADDRESS 0x41230000
#define RESET_ADDRESS 0x41230008

#define FINISH_ADDRESS 0x41210000
#define RESULT_FASE_LOW_ADDRESS 0x41200000
#define RESULT_FASE_HIGH_ADDRESS 0x41200008
#define RESULT_CUAD_LOW_ADDRESS 0x41220000
#define RESULT_CUAD_HIGH_ADDRESS 0x41220008

#define FIFO_1_ADDRESS 0x43c00000
#define FIFO_2_ADDRESS 0x43c10000
#define FIFO_3_ADDRESS 0x43c20000

#define M_ADDRESS 0x41240000
#define N_ADDRESS 0x41240008

#define PI 3.1415


void ResetFPGA(void *cfg);
void SetEnable(void *cfg);
void SetN_ma(void *cfg,uint32_t N_ma);
void SetM(void *cfg, uint32_t M);
uint32_t getFinish(void *cfg);

uint32_t get_fase_low(void *cfg);
uint32_t get_fase_high(void *cfg);
uint32_t get_cuad_low(void *cfg);
uint32_t get_cuad_high(void *cfg);

double custom_pow(double base, int exponent) ;
double mySqrt(double x) ;
void leerFIFO(void *cfg,int N_reads,int fifo_address);
void leerFIFO64(void *cfg,int N_reads,int fifo_address_high,int fifo_address_low);
void ClearEnable(void *cfg);

int main(int argc, char **argv)
{
    int fd;
    void *cfg;
    char *name = "/dev/mem";
	
	printf("Programa de prueba para lockin en Red Pitaya \n");

	// Parametros desde linea de comandos:
	uint32_t M;
	uint32_t N_ma;
	
	if(argc==2 && argv[1] == "h")
	{
		printf("Uso -> lockin N_ma M \n");
		return 0;
	}
	else if(argc==3)
	{
		N_ma = atoi(argv[1]);
		M = atoi(argv[2]);	
	}		
	else
	{
		printf("Error en los argumentos ingresados (Ingreso %d y se esperaban 2)\n",argc-1);
		printf("Uso -> lockin N_ma M \n");
		return 0;
	}
	
	
    // Mapeo el espacio de memoria de la FPGA al puntero cfg
    if((fd = open(name, O_RDWR)) < 0)
    {
        perror("open");
        return 1;
    }

    cfg = mmap(NULL, 0x4000000, PROT_READ|PROT_WRITE, MAP_SHARED, fd, START_ADDRESS);
	
	// Seteo los parametros de la operacion a traves de funciones por prolijidad
	SetM(cfg,M);
	SetN_ma(cfg,N_ma);

	ResetFPGA(cfg);
	SetEnable(cfg);

	// Espero a la señal de finzalizacion
	while  ( getFinish(cfg) == 0 ) 	{}
	
	int64_t resultado_fase,resultado_cuadratura;

	uint32_t res_up = get_fase_high(cfg);
	uint32_t res_low = get_fase_low(cfg);
	resultado_fase = ((uint64_t)res_up << 32) | (uint64_t)res_low ;

	printf("\nFASE HIGH = %u ",res_up);
	printf("\nFASE LOW = %u ",res_low);	
	printf("\n	-> Resultado fase: %lld",resultado_fase);

	res_up = get_cuad_high(cfg);		
	res_low = get_cuad_low(cfg);		
	resultado_cuadratura = ((uint64_t)res_up << 32) | (uint64_t)res_low ;


	printf("\nCUAD HIGH = %u ",res_up);
	printf("\nCUAD LOW = %u ",res_low);	
	printf("\n	-> Resultado cuad: %lld",resultado_cuadratura);

	double amplitud_ref = 32767;

 	double x = (double)resultado_fase / (M*N_ma);
    double y = (double)resultado_cuadratura / (M*N_ma);

	double r = (sqrt(x*x + y*y)) * 2 / amplitud_ref;
	double phi = atan2(y,x)*180/PI;

	printf("\nResultados: \n R= %f \n phi= %f \n\n",r,phi);   

	//leerFIFO(cfg,2*M,FIFO_1_ADDRESS);
	//leerFIFO(cfg,2*M,FIFO_2_ADDRESS);
	//leerFIFO(cfg,2*M,FIFO_3_ADDRESS);

	ClearEnable(cfg);
	ResetFPGA(cfg);

    munmap(cfg, sysconf(_SC_PAGESIZE));

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

void SetEnable(void *cfg)
{
	// Seteo el enable (o trigger)
	*(uint32_t *)(cfg+ ENABLE_ADDRESS - START_ADDRESS ) = 1;		
	
}

void ClearEnable(void *cfg)
{
	// Seteo el enable (o trigger)
	*(uint32_t *)(cfg+ ENABLE_ADDRESS - START_ADDRESS ) = 0;		
	
}

void SetN_ma(void *cfg,uint32_t N_ma)
{
	// Seteo la cantidad de muestras que quiero promediar coherentemente 
	*(uint32_t *)(cfg+ N_ADDRESS - START_ADDRESS) = N_ma ;
}

void SetM(void *cfg, uint32_t M)
{
	// Seteo la cantidad de muestras por ciclo de señal 
	*(uint32_t *)(cfg+ M_ADDRESS - START_ADDRESS) = M ;

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


// Funciones para leer los FIFO.. esta los toma como FIFOS independientes
void leerFIFO(void *cfg,int N_reads,int fifo_address)
{
	int i = 0;
	printf("Lecturas del FIFO: \n");
	for (i=0;i<514;i++){		
		uint32_t read = *((uint32_t *)(cfg+ fifo_address - START_ADDRESS + 0x20) );
		if(i<N_reads)
		{
			printf("%u, ",read);
		}
	}
	printf("\n\n");
}

// Funcion para leer dos FIFOS de 32 bits como si fueran un unico FIFO de 64 bits
void leerFIFO64(void *cfg,int N_reads,int fifo_address_high,int fifo_address_low)
{
	int i = 0;
	printf("Lecturas del FIFO: \n");
	for (i=0;i<514;i++){		

		int64_t resultado_fase;
		uint32_t res_up = *((uint32_t *)(cfg+ fifo_address_high - START_ADDRESS + 0x20) );
		uint32_t res_low = *((uint32_t *)(cfg+ fifo_address_low - START_ADDRESS + 0x20) );
		resultado_fase = ((uint64_t)res_up << 32) | (uint64_t)res_low ;

		if(i<N_reads)
		{
			printf("%lld, ",resultado_fase);
		}
	}
	printf("\n\n");
}



