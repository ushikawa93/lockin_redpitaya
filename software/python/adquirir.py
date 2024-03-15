# -*- coding: utf-8 -*-
"""
Created on Thu Nov 23 12:47:18 2023

@author: MatiOliva
"""

from red_pitaya_class import redP_handler
from red_pitaya_class import DataMode
import matplotlib.pyplot as plt
import os


rp = redP_handler("192.168.1.104")

# Solo la primera vez:
rp.set_bitstream_in_fpga("lockin.bit")

rp.set_M(32)
rp.set_N(64)
rp.set_noise_bits(0)
rp.set_data_mode(DataMode.SIMULACION)

data=rp.measure_lockin()