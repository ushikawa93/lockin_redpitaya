# -*- coding: utf-8 -*-
"""
Created on Thu Nov 23 12:47:18 2023

@author: MatiOliva
"""

from red_pitaya_class import redP_handler
from red_pitaya_class import DataMode
from red_pitaya_class import DecimatorMethod
import matplotlib.pyplot as plt


set_bitstream = True
plot_adc = True

#ip = "169.254.172.188"
ip = "192.168.1.102"

rp = redP_handler(ip)

# Solo la primera vez:
if(set_bitstream):
    rp.set_bitstream_in_fpga("lockin_new.bit")

r_new_3=[]

for i in range(1,2):

    rp.set_data_mode(DataMode.ADC)
    rp.set_decimator_method(DecimatorMethod.PROM)
    
    frec_ref = 10000;
    rp.set_frec_ref(frec_ref)
    
    frec_dac = 10000;
    rp.set_frec_dac(frec_dac)
    
    N = 1
    rp.set_N(N)
    
    decimator = 100
    rp.set_decimator(decimator)    
    
    data=rp.measure_lockin()
    print(f"Frec: {data['f']}")
    print(f"R: {data['r']}")
    print(f"phi: {data['phi']}")
    
    r_new_3.append(data['r'])
    
    

if(plot_adc):
    plt.plot(data['datos_adc'],marker='x');
    plt.grid()
