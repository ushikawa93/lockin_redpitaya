
#///// ========================== LOCKIN.SH ================================== /////
#///// ========================================================================= /////
#///// Scipt que utiliza el programa lockin.c para calcular el lockin con la FPGA /////
#///// ========================================================================= /////
#
# Script para calcular lockin en la FPGA y mostrar resultados
# Uso -> lockin N_ma frec_dac frec_ref data_sel IP 

N_ma=${1:-2}
frec_dac=${2:-1000000}
frec_ref=${3:-1000000}
data_sel=${4,-0}
ip=${5:-169.254.172.188}

scp ../c_program/lockin.c root@$ip:/root/c_programs 

ssh root@$ip <<EOF

	cd /root/c_programs 
	gcc lockin.c -o lockin -lm
	./lockin $N_ma $frec_dac $frec_ref $data_sel
EOF

scp root@$ip:/root/c_programs/resultados.dat ../datos_adquiridos/resultados.dat
scp root@$ip:/root/c_programs/resultados_adc.dat ../datos_adquiridos/resultados_adc.dat

read -p "Presione cualquier tecla para salir..."
