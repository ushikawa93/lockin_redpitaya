# ============================================================================================================
# Script: lockin.sh
# ============================================================================================================
# Descripción:
#   Este script ejecuta el programa lockin.c en la FPGA (Red Pitaya) para calcular la señal lock-in de la
#   señal de entrada. Los resultados se copian luego a la PC HOST para su posterior análisis.
#
# Uso:
#   ./lockin.sh N_ma frec_dac frec_ref data_sel decimator decimator_method IP
#
# Parámetros:
#   N_ma               -> Número de ciclos de medición para promediado coherente.
#   frec_dac           -> Frecuencia de la señal de salida del DAC (Hz).
#   frec_ref           -> Frecuencia de referencia (Hz).
#   data_sel            -> Fuente de datos: simulación o ADC (definida en el código C).
#   decimator           -> Factor de decimación.
#   decimator_method    -> Método de decimación (descarte o promedio lineal).
#   IP                  -> Dirección IP de la Red Pitaya.
#
# Funcionamiento:
#   1. Copia el código fuente lockin.c a la Red Pitaya vía scp.
#   2. Compila el programa directamente en la FPGA usando gcc.
#   3. Ejecuta el programa con los parámetros indicados.
#   4. Copia los archivos de resultados "resultados.dat" y "resultados_adc.dat" a la carpeta
#      ../datos_adquiridos en la PC HOST.
#
# Notas:
#   - Requiere acceso SSH con usuario root en la Red Pitaya.
#   - Los parámetros tienen valores por defecto para simplificar la ejecución.
#   - Se recomienda verificar la conectividad antes de ejecutar el script.
#
# Autor: Matías Oliva
# Fecha: 2025
# ============================================================================================================


N_ma=${1:-2}
frec_dac=${2:-1000000}
frec_ref=${3:-1000000}
data_sel=${4,-0}
decimator=${5,-1}
decimator_method=${6,-0}
ip=${7:-169.254.172.188}

scp ../c_program/lockin.c root@$ip:/root/c_programs 

ssh root@$ip <<EOF

	cd /root/c_programs 
	gcc lockin.c -o lockin -lm
	./lockin $N_ma $frec_dac $frec_ref $data_sel $decimator $decimator_method
EOF

scp root@$ip:/root/c_programs/resultados.dat ../datos_adquiridos/resultados.dat
scp root@$ip:/root/c_programs/resultados_adc.dat ../datos_adquiridos/resultados_adc.dat

#read -p "Presione cualquier tecla para salir..."
