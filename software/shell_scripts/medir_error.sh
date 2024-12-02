
#///// ========================== medir_error.SH ================================== /////
#///// ========================================================================= /////
#///// Scipt que utiliza el programa medir_error.c para medir errores con la FPGA /////
#///// ========================================================================= /////
#
# Script para calcular lockin en la FPGA y mostrar resultados
# Uso -> medir_error N f n_iteraciones fuente nombre_archivo_salida IP 

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
