# ============================================================================================================
# Script: barrido_ctes_tiempo.sh
# ============================================================================================================
# Descripción:
#   Este script ejecuta el programa barrido_ctes_tiempo.c en la FPGA (Red Pitaya) para calcular el lock-in
#   en diferentes valores de N (tiempo de integración). Los resultados se copian luego a la PC HOST.
#
# Uso:
#   ./barrido_ctes_tiempo.sh frec N_inicial N_final iteraciones fuente nombre_archivo_salida ip
#
# Parámetros:
#   frec                 -> Frecuencia de referencia (Hz).
#   N_inicial            -> Valor inicial de N (cantidad de ciclos promediados).
#   N_final              -> Valor final de N.
#   iteraciones          -> Cantidad de iteraciones para promediar los resultados.
#   fuente               -> Fuente de señal (definición en el código C).
#   nombre_archivo_salida-> Nombre del archivo de salida con los datos adquiridos.
#   ip                   -> Dirección IP de la Red Pitaya.
#
# Funcionamiento:
#   1. Copia el código fuente barrido_ctes_tiempo.c a la Red Pitaya vía scp.
#   2. Compila el programa directamente en la FPGA usando gcc.
#   3. Ejecuta el programa con los parámetros indicados.
#   4. Copia el archivo de resultados a la carpeta ../datos_adquiridos de la PC HOST.
#
# Notas:
#   - Requiere acceso SSH con usuario root en la Red Pitaya.
#   - Los parámetros tienen valores por defecto para facilitar la ejecución rápida.
#   - Se recomienda verificar la conectividad antes de ejecutar el script.
#
# Autor: Matías Oliva
# Fecha: 2025
# ============================================================================================================

frec=${1:-2}
N_inicial=${2:-1000000}
N_final=${3:-1000000}
iteraciones=${4,-0}
fuente=${5,-1}
nombre_archivo_salida=${6,-0}
ip=${7:-169.254.172.188}

scp ../c_program/barrido_ctes_tiempo.c root@$ip:/root/c_programs 

ssh root@$ip <<EOF

	cd /root/c_programs 
	gcc barrido_ctes_tiempo.c -o barrido_ctes_tiempo -lm
	./barrido_ctes_tiempo $frec $N_inicial $N_final $iteraciones $fuente $nombre_archivo_salida
EOF

scp root@$ip:/root/c_programs/$nombre_archivo_salida ../datos_adquiridos/$nombre_archivo_salida

#read -p "Presione cualquier tecla para salir..."
