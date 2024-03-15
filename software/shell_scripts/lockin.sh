
#///// ========================== LOCKIN.SH ================================== /////
#///// ========================================================================= /////
#///// Scipt que utiliza el programa lockin.c para calcular el lockin con la FPGA /////
#///// ========================================================================= /////
#
# Script para calcular lockin en la FPGA y mostrar resultados
# Uso -> lockin N_ma | M | noise_bits | data_sel | IP 

N_ma=${1:-2}
M=${2:-32}
noise_bits=${3:-0}
data_sel=${4,-0}
ip=${5:-169.254.172.188}

scp ../c_program/lockin.c root@$ip:/root/c_programs 

ssh root@$ip <<EOF

	cd /root/c_programs 
	gcc lockin.c -o lockin -lm
	./lockin $N_ma $M $noise_bits $data_sel
EOF

scp root@$ip:/root/c_programs/resultados.dat ../datos_adquiridos/resultados.dat


read -p "Presione cualquier tecla para salir..."
