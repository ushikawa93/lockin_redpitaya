# -*- coding: utf-8 -*-
"""
Created on Thu Nov 23 12:47:18 2023

@author: MatiOliva
"""

from red_pitaya_class import redP_handler
from red_pitaya_class import DataMode
import matplotlib.pyplot as plt

plot_adc = False
set_bitstream = False

ip = "169.254.172.188"
#ip = "192.168.1.104"

rp = redP_handler(ip)

# Solo la primera vez:
if(set_bitstream):
    rp.set_bitstream_in_fpga("experimental_2.bit")


rp.set_data_mode(DataMode.SIMULACION)

frec_ref = 1000000;
rp.set_frec_ref(frec_ref)

frec_dac = 1000000;
rp.set_frec_dac(frec_dac)

N = 1
rp.set_N(N)    
data=rp.measure_lockin()

print(f"Frec: {data['f']}")
print(f"R: {data['r']}")
print(f"phi: {data['phi']}")

if(plot_adc):
    plt.plot(data['datos_adc']);
