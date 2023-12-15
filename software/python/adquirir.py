# -*- coding: utf-8 -*-
"""
Created on Thu Nov 23 12:47:18 2023

@author: MatiOliva
"""

from red_pitaya_class import redP_handler
from red_pitaya_class import TriggerMode
import matplotlib.pyplot as plt
import os


rp = redP_handler("192.168.1.100")

# Solo la primera vez:
#rp.set_bitstream_in_fpga();


rp.set_frec_objetivo(100)
rp.set_prom_coherente(2)
rp.set_trigger_mode(TriggerMode.DISPARO_EXTERNO)
rp.set_trigger_level(0)


print(rp.get_estado())
data_path = os.path.join("datos_adquiridos", rp.get_archivo_destino())

rp.adquirir()

data,metadata = rp.leer_archivo(data_path)

div = (metadata[1]*metadata[2]/metadata[3]);

data_ch_0 = [elemento / div for elemento in data[0]]
data_ch_1 = [elemento / div for elemento in data[1]]


plt.plot(data_ch_0);plt.grid();
plt.plot(data_ch_1)

#print(data[2])

plt.show()
