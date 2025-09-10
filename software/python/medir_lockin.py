# -*- coding: utf-8 -*-

# ===================================================================================== #
# ========================== Control y Adquisición desde PC Host ====================== #
# ===================================================================================== #
#
# Script en Python que permite controlar y ejecutar la lógica de lock-in digital 
# implementada en la Red Pitaya desde una computadora host conectada por red.
#
# Funcionalidades principales:
#   - Configuración remota de parámetros de adquisición:
#       · Frecuencia de referencia (frec_ref)
#       · Frecuencia de DAC (frec_dac)
#       · Factor de decimación y método de descarte
#       · Número de promediaciones (N)
#   - Opción de cargar el bitstream en la FPGA (solo necesario la primera vez).
#   - Ejecución de medidas lock-in para obtener:
#       · Magnitud R (convertida a voltios)
#       · Fase φ
#       · Señales crudas del ADC
#   - Visualización opcional de las muestras adquiridas desde el ADC.
#
# Dependencias:
#   - red_pitaya_class.py  (clase de control de la Red Pitaya)
#   - matplotlib
#
# Uso:
#   1. Configurar la IP de la Red Pitaya.
#   2. Ajustar parámetros de adquisición (frecuencias, N, decimación).
#   3. Ejecutar el script para medir y graficar resultados.
#
# ===================================================================================== #


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
