
# Pequeño script para mandar el bitstream a la FPGA 
# Uso -> copy_bitstream {archivo.bit} {red pitaya IP}

name=${1:-lockin.bit}
ip=${2:-192.168.1.100}


scp $name root@$ip:/root/bitstreams 

ssh root@$ip <<EOF
cp  /root/bitstreams/$name /root/bitstreams/fpga.bit
cat /root/bitstreams/fpga.bit > /dev/xdevcfg
EOF

read -p "Presione cualquier tecla para salir..."
