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
import numpy as np

set_bitstream = False
plot = True
pasa_bajos = False

ip = "192.168.1.102"

rp = redP_handler(ip)

# Solo la primera vez:
if(set_bitstream):
    rp.set_bitstream_in_fpga("lockin_experimental.bit")

rp.set_data_mode(DataMode.ADC)
rp.set_decimator_method(DecimatorMethod.PROM)

N = 512
rp.set_N(N)

decimator = 1
rp.set_decimator(decimator)

f_inicial = 200
f_final = 500000
f_step = 200

data = rp.barrido_en_frecuencia(f_inicial, f_final, f_step)

# Encontrar el punto donde la fase es aproximadamente -45 grados
frecuencias = np.array(data['f'])
fase = np.array(data['phi'])

# Busca el índice más cercano a -45 grados
if pasa_bajos:
    indice_frecuencia_corte = np.argmin(np.abs(fase + 45))
else:
    indice_frecuencia_corte = np.argmin(np.abs(fase - 45))
    
frecuencia_corte = frecuencias[indice_frecuencia_corte]

if plot:
    plt.figure()
    
    plt.subplot(2, 1, 1)  # 2 filas, 1 columna, índice 1
    plt.semilogx(frecuencias, data['r'], marker='x')
    plt.axvline(x=frecuencia_corte, color='r', linestyle='--', label='Frecuencia de corte (-45°)')
    plt.grid()
    plt.title('Gráfico de f vs r')
    plt.legend()
    
    plt.subplot(2, 1, 2)  # 2 filas, 1 columna, índice 2
    plt.semilogx(frecuencias, fase, marker='x')
    plt.axvline(x=frecuencia_corte, color='r', linestyle='--', label='Frecuencia de corte (-45°)')
    plt.grid()
    plt.title('Gráfico de f vs phi')
    plt.legend()

    # Añadir una etiqueta en el gráfico para la frecuencia de corte
    plt.text(frecuencia_corte * 1.1, -40, f'{frecuencia_corte:.1f} Hz', color='black', fontsize=12,
         verticalalignment='bottom', horizontalalignment='left')
    
    plt.tight_layout()
    plt.show()