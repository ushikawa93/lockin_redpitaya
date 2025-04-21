name=${1:-fpga.bit}

cp  /root/fpga/$name /root/fpga/fpga.bit
cat /root/fpga/fpga.bit > /dev/xdevcfg