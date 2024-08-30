# -*- coding: utf-8 -*-
"""
Created on Fri Aug 30 14:50:06 2024

@author: MatiOliva
"""


# Barrido en frecuencia del lockin en red pitaya...


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

N = 100;
rp.set_N(N);

decimator = 1;
rp.set_decimator(decimator);

f_inicial = 1000;
f_final = 1400;
f_step = 1;

data = rp.barrido_en_frecuencia(f_inicial, f_final, f_step,1200);

if(plot):
    plt.figure()
    
    plt.subplot(2, 1, 1)  # 2 filas, 1 columna, índice 1
    plt.plot(data['f'], data['r'], marker='x')
    plt.grid()
    plt.title('Gráfico de f vs r')
    
    plt.subplot(2, 1, 2)  # 2 filas, 1 columna, índice 2
    plt.plot(data['f'], data['phi'], marker='x')
    plt.grid()
    plt.title('Gráfico de f vs phi')
    
    plt.tight_layout()
    plt.show()

