# ============================================================================================================
# Script: medir_error.sh
# ============================================================================================================
# Descripción:
#   Este script ejecuta el programa medir_error.c en la FPGA (Red Pitaya) para calcular errores de medición
#   de la señal lock-in según distintas condiciones. Los resultados se copian luego a la PC HOST.
#
# Uso:
#   ./medir_error.sh N frec n_iteraciones fuente nombre_archivo_salida IP
#
# Parámetros:
#   N                    -> Número de ciclos de medición para promediado coherente.
#   frec                 -> Frecuencia de referencia (Hz).
#   n_iteraciones        -> Cantidad de iteraciones a promediar.
#   fuente               -> Fuente de datos: simulación o ADC (definida en el código C).
#   nombre_archivo_salida -> Nombre del archivo donde se guardarán los resultados.
#   IP                   -> Dirección IP de la Red Pitaya.
#
# Funcionamiento:
#   1. Copia el código fuente medir_error.c a la Red Pitaya vía scp.
#   2. Compila el programa directamente en la FPGA usando gcc.
#   3. Ejecuta el programa con los parámetros indicados.
#   4. Copia el archivo de resultados especificado a la carpeta ../datos_adquiridos en la PC HOST.
#
# Notas:
#   - Requiere acceso SSH con usuario root en la Red Pitaya.
#   - Los parámetros tienen valores por defecto para simplificar la ejecución.
#   - Se recomienda verificar la conectividad antes de ejecutar el script.
#
# Autor: Matías Oliva
# Fecha: 2025
# ============================================================================================================


N=${1:-2}
frec=${2:-100000}
n_iteraciones=${3:-100}
fuente=${4:-1}
nombre_archivo_salida=${5:-medidas_de_error.dat}
ip=${6:-169.254.16.100}

scp ../c_program/medir_error.c root@$ip:/root/c_programs 

ssh root@$ip <<EOF

	cd /root/c_programs 
	gcc medir_error.c -o medir_error -lm
	./medir_error $N $frec $n_iteraciones $fuente $nombre_archivo_salida
EOF

scp root@$ip:/root/c_programs/$nombre_archivo_salida ../datos_adquiridos/$nombre_archivo_salida

#read -p "Presione cualquier tecla para salir..."
