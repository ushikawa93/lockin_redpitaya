

#///// ================================== barrido_en_frecuencia.sh ============================================ /////
#///// ======================================================================================================== /////
#///// Scipt que utiliza el programa barrido_en_frecuencia.c para calcular el lockin con la FPGA en distintas N /////
#///// ======================================================================================================== /////
#
# Script para calcular lockin en la FPGA y mostrar resultados
# Uso -> barrido_en_frecuencia N f_inicial f_final f_step f_dac fuente nombre_archivo_salida ip

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
