# ============================================================================================================
# Script: barrido_en_frecuencia.sh
# ============================================================================================================
# Descripción:
#   Este script ejecuta el programa barrido_en_frecuencia.c en la FPGA (Red Pitaya) para calcular la respuesta
#   del lock-in a distintas frecuencias de excitación. Los resultados se copian luego a la PC HOST.
#
# Uso:
#   ./barrido_en_frecuencia.sh N f_inicial f_final f_step f_dac fuente nombre_archivo_salida ip
#
# Parámetros:
#   N                    -> Cantidad de ciclos promediados.
#   f_inicial            -> Frecuencia inicial de barrido (Hz).
#   f_final              -> Frecuencia final de barrido (Hz).
#   f_step               -> Paso de incremento de frecuencia (Hz).
#   f_dac                -> Frecuencia de la señal de salida DAC (Hz).
#   fuente               -> Fuente de señal (definida en el código C).
#   nombre_archivo_salida-> Nombre del archivo de salida con los datos adquiridos.
#   ip                   -> Dirección IP de la Red Pitaya.
#
# Funcionamiento:
#   1. Copia el código fuente barrido_en_frecuencia.c a la Red Pitaya vía scp.
#   2. Compila el programa directamente en la FPGA usando gcc.
#   3. Ejecuta el programa con los parámetros indicados.
#   4. Copia el archivo de resultados a la carpeta ../datos_adquiridos de la PC HOST.
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
f_inicial=${2:-1000000}
f_final=${3:-1000000}
f_step=${4,-0}
f_dac=${5,-0}
fuente=${6,-1}
nombre_archivo_salida=${7,-0}
ip=${8:-169.254.172.188}

scp ../c_program/barrido_en_frecuencia.c root@$ip:/root/c_programs 

ssh root@$ip <<EOF
	cd /root/c_programs 
	gcc barrido_en_frecuencia.c -o barrido_en_frecuencia -lm
	./barrido_en_frecuencia $N $f_inicial $f_final $f_step $f_dac $fuente $nombre_archivo_salida
EOF

scp root@$ip:/root/c_programs/$nombre_archivo_salida ../datos_adquiridos/$nombre_archivo_salida

#read -p "Presione cualquier tecla para salir..."
