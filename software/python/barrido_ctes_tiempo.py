# -*- coding: utf-8 -*-
"""
Created on Thu Aug 29 17:40:03 2024

@author: mati9
"""

# Barrido de constantes de tiempo con lockin en red pitaya...


from red_pitaya_class import redP_handler
from red_pitaya_class import DataMode
from red_pitaya_class import DecimatorMethod
import matplotlib.pyplot as plt


set_bitstream = False
plot = True

ip = "192.168.1.102"

rp = redP_handler(ip)

# Solo la primera vez:
if(set_bitstream):
    rp.set_bitstream_in_fpga("lockin_new.bit")

rp.set_data_mode(DataMode.ADC)
rp.set_decimator_method(DecimatorMethod.PROM)

frec_ref = 1000000;
rp.set_frec_ref(frec_ref)

frec_dac = 1000000;
rp.set_frec_dac(frec_dac)

decimator = 1
rp.set_decimator(decimator)    

N_inicial = 1
N_final = 4096
iteraciones = 100;

data = rp.barrido_ctes_tiempo(N_inicial, N_final, iteraciones)

if(plot):
    plt.plot(data['N'],data['std_r'],marker='x');
    plt.grid()    

