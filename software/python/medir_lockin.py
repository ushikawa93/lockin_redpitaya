# -*- coding: utf-8 -*-
"""
Created on Thu Nov 23 12:47:18 2023

@author: MatiOliva
"""

from red_pitaya_class import redP_handler
from red_pitaya_class import DataMode
import matplotlib.pyplot as plt
import os

ip = "169.254.172.188"
#ip = "192.168.1.104"

rp = redP_handler(ip)

# Solo la primera vez:
#rp.set_bitstream_in_fpga("lockin_ref_dds.bit")

frec_ref = 4000000;
rp.set_N(100)
rp.set_data_mode(DataMode.ADC)
rp.set_frec_ref(frec_ref)


frec_dac = 4000000;
rp.set_frec_dac(frec_dac)    
data=rp.measure_lockin()
print(data)

"""

r = []

frec_dac = range (4500,5500,50)

for f in frec_dac:
    
    
    rp.set_frec_dac(f)    
    data=rp.measure_lockin()
    r.append(data['r'])

plt.plot(frec_dac,r)
plt.show()
"""