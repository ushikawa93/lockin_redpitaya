# -*- coding: utf-8 -*-
"""
Created on Thu Nov 23 12:47:18 2023

@author: MatiOliva
"""

from red_pitaya_class import redP_handler
from red_pitaya_class import DataMode
from red_pitaya_class import DecimatorMethod
import matplotlib.pyplot as plt


set_bitstream = False
plot_adc = True

#ip = "169.254.172.188"
ip = "169.254.16.100"

rp = redP_handler(ip)

# Solo la primera vez:
if(set_bitstream):
    rp.set_bitstream_in_fpga("lockin_experimental.bit")

r_new_3=[]

for i in range(1,2):

    rp.set_data_mode(DataMode.ADC)
    rp.set_decimator_method(DecimatorMethod.DISCARD)
    
    frec_ref = 100000;
    rp.set_frec_ref(frec_ref)
    
    frec_dac = frec_ref;
    rp.set_frec_dac(frec_dac)
    
    N = 1
    rp.set_N(N)
    
    decimator = 10
    rp.set_decimator(decimator)    
    
    data=rp.measure_lockin()
    
    R = redP_handler.convertir2volt_lockin(data['r']);
    
    print(f"Frec: {data['f']}")
    print(f"R: {R}")
    print(f"phi: {data['phi']}")
    
    r_new_3.append(data['r'])
    
    

if(plot_adc):
    tensiones = [redP_handler.convertir2volt_adc(valor) for valor in (data['datos_adc'])]
    plt.plot(tensiones,marker='x');
    plt.grid()
