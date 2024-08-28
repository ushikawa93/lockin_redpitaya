
#///// ========================== LOCKIN.SH ================================== /////
#///// ========================================================================= /////
#///// Scipt que utiliza el programa lockin.c para calcular el lockin con la FPGA /////
#///// ========================================================================= /////
#
# Script para calcular lockin en la FPGA y mostrar resultados
# Uso -> barrido_ctes_tiempo frec N_inicial N_final iteraciones fuente nombre_archivo_salida ip

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

read -p "Presione cualquier tecla para salir..."
