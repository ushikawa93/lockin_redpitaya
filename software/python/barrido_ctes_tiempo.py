# -*- coding: utf-8 -*-

# ===================================================================================== #
# =========== Barrido de Constantes de Tiempo con Lock-in en Red Pitaya =============== #
# ===================================================================================== #
#
# Script en Python para ejecutar un barrido de constantes de tiempo utilizando la 
# clase `redP_handler` y una Red Pitaya configurada como lock-in digital.
#
# Funcionalidad:
#   - Configuración de la conexión a la Red Pitaya mediante IP.
#   - Carga opcional del bitstream de la FPGA (solo la primera vez).
#   - Selección del modo de datos (ADC) y del método de decimación (promediado).
#   - Configuración de frecuencias de referencia y de salida DAC.
#   - Definición de parámetros del barrido:
#       · N_inicial: valor mínimo de promediaciones
#       · N_final: valor máximo de promediaciones
#       · iteraciones: número de repeticiones por punto
#   - Ejecución del barrido llamando a `rp.barrido_ctes_tiempo`.
#   - Visualización opcional de la desviación estándar `std_r` frente a `N`.
#
# Dependencias:
#   - red_pitaya_class (clase redP_handler, DataMode, DecimatorMethod)
#   - matplotlib.pyplot
#
# Uso típico:
#   1. Ajustar la IP de la Red Pitaya.
#   2. (Opcional) habilitar `set_bitstream=True` la primera vez para cargar el bitstream.
#   3. Configurar frecuencias, decimador y rango de N.
#   4. Ejecutar el script para obtener y graficar los resultados del barrido.
#
# ===================================================================================== #


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

