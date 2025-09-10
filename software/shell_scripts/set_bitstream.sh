# ============================================================================================================
# Script: copy_bitstream.sh
# ============================================================================================================
# Descripción:
#   Este script permite cargar un archivo bitstream (.bit) en la FPGA Red Pitaya desde la PC HOST.
#   El bitstream se copia primero al directorio /root/bitstreams de la FPGA y luego se programa.
#
# Uso:
#   ./copy_bitstream.sh {archivo.bit} {IP_Red_Pitaya}
#
# Parámetros:
#   archivo.bit    -> Nombre del archivo bitstream a cargar (por defecto "lockin.bit").
#   IP_Red_Pitaya  -> Dirección IP de la Red Pitaya (por defecto 169.254.16.100).
#
# Funcionamiento:
#   1. Copia el archivo bitstream desde ../bitstreams en la PC HOST a /root/bitstreams en la FPGA vía SCP.
#   2. Renombra el archivo como fpga.bit y lo programa usando el dispositivo /dev/xdevcfg.
#   3. Permite que la FPGA cargue la lógica correspondiente al bitstream.
#
# Notas:
#   - Requiere acceso SSH con usuario root en la Red Pitaya.
#   - Se puede modificar el archivo y la IP desde la línea de comando para diferentes configuraciones.
#   - Después de ejecutar, la FPGA estará lista para ejecutar los programas Lock-in.
#
# Autor: mati9
# Fecha: (poner fecha)
# ============================================================================================================

name=${1:-lockin.bit}
ip=${2:-169.254.16.100}


scp ../bitstreams/$name root@$ip:/root/bitstreams 

ssh root@$ip <<EOF
cp  /root/bitstreams/$name /root/bitstreams/fpga.bit
cat /root/bitstreams/fpga.bit > /dev/xdevcfg
EOF

#read -p "Presione cualquier tecla para salir..."
