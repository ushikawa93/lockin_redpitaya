
#///// ========================== LOCKIN.SH ================================== /////
#///// ========================================================================= /////
#///// Scipt que utiliza el programa lockin.c para calcular el lockin con la FPGA /////
#///// ========================================================================= /////
#
# Script para calcular lockin en la FPGA y mostrar resultados
# Uso -> lockin N_ma | M | IP

# Uso del programa adquisidor -> adquisidor FACTOR_SOBREMUESTREO | CICLOS_PROMEDIADOS | NOMBRE_ARCHIVO_SALIDA | MAXIMO_BUFFER  | FREC_DAC | TRIGGER_MODE | TRIGGER_LEVEL | LOG2_DIVISOR | ADC_THRESHOLD

N_ma=${1:-2}
M=${2:-64}
ip=${3:-169.254.172.188}

scp lockin.c root@$ip:/root/c_programs 

ssh root@$ip <<EOF

	cd /root/c_programs 
	gcc lockin.c -o lockin
	./lockin $N_ma $M
EOF


read -p "Presione cualquier tecla para salir..."
