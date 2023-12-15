
#///// ===================== SET_ADC_THRESHOLD.SH ========================================= /////
#///// ==================================================================================== /////
#///// Scipt que utiliza el programa adquisidor.c para setear el valor de threshold del ADC /////
#///// ==================================================================================== /////
#
# Script para setear el valor a partir del cual el ADC de la red pitaya prende el LED y activa el GPIO
# Uso -> SET_ADC_THRESHOLD.sh ADC_THRESHOLD | IP  

# Uso del programa adquisidor -> adquisidor FACTOR_SOBREMUESTREO | CICLOS_PROMEDIADOS | NOMBRE_ARCHIVO_SALIDA | MAXIMO_BUFFER  | FREC_DAC | TRIGGER_MODE | TRIGGER_LEVEL | LOG2_DIVISOR | ADC_THRESHOLD


adc_threshold_level=${1,-0}
ip=${2:-192.168.1.100}


scp adquisidor.c root@$ip:/root/c_programs 

ssh root@$ip <<EOF

	cd /root/c_programs 
	gcc adquisidor.c -o adquisidor
	./adquisidor $adc_threshold_level
EOF


#read -p "Presione cualquier tecla para salir..."
