# lockin_redpitaya
Detección Lock-in usando Red Pitaya con adquisición de señales, procesamiento y generación de triggers.

# Carpeta Hardware
Hardware implementado en la FPGA mediante un "block diagram" que combina módulos propios y algunas IPs de Xilinx. Los módulos principales son:

+ **Control:** Interfaz con el microprocesador embebido para controlar la FPGA, configurar parámetros y leer resultados. Los parámetros modificables son:
  - `N_ma`: Número de ciclos promediados en el Moving Average Filter (MAF) del lock-in.
  - `data_source`: Selección de fuente de datos (0: simulación, 1: ADC).
  - `dac_phase`: Incremento de fase para el DDS que genera la señal de salida del DAC.
  - `ref_phase`: Incremento de fase para el DDS de las referencias del lock-in.
  - `decimate_value`: Valor de decimación para la visualización de señales.
  - `decimate_mode`: Modo de decimación (0: descarte, 1: promedio lineal).
  - `M`: Puntos por ciclo de señal, usado principalmente para estimar el paso por cero de la señal DDS.

+ **Fuente de datos (`data_source` y `data_stream`):** Genera las señales de entrada para el lock-in, que pueden provenir del ADC o ser simuladas. Incluye opciones de:
  - Señales con ruido generado por LFSR o generador congruencial lineal (GCL) con control de amplitud.
  - Ajuste dinámico del número de puntos por ciclo (`ptos_x_ciclo` o `M`) y paso por cero.
  - Salida de señal y señal de cruce por cero (`zero_cross`) para sincronización.
  
+ **Decimador:** Reduce la cantidad de datos para visualización, manteniendo la señal original completa para el lock-in.

+ **Lock-in (`coherent_average`):** Calcula las componentes X e Y mediante un Lockin que utiliza un filtro MAF coherente sobre `N_ma` ciclos.  
  - Calcular R y φ externamente: `R = sqrt(X^2 + Y^2)`, `phi = atan(Y/X)`.
  - Incluye memoria para almacenar índices de cada ciclo de promediado, asegurando integridad de la secuencia.

+ **DAC:** Genera una señal sinusoidal de salida mediante un DDS, configurable por `dac_phase`.

+ **Trigger Simulator (`trigger_simulator`):** Permite probar y sincronizar la adquisición mediante tres modos de trigger:
  - Trigger continuo: genera un pulso cada M muestras.
  - Trigger de nivel: detecta flancos ascendentes sobre un nivel de referencia, con hold-off para evitar rebotes.
  - Trigger externo: activado mediante una señal digital externa con hold-off incorporado.

+ **Level Detector (`level_detector`):** Detecta cuando las entradas superan un nivel definido, usado para disparar eventos o triggers internos.

+ **GPIO y LEDs (`drive_gpios`, `drive_leds`):** Controla salidas físicas, LEDs y permite visualizar estados de señales internas.

# Carpeta Software
Contiene scripts y funciones en Python y c para controlar la FPGA y el lock-in:

- Se comunica con la FPGA vía SSH y usa shell scripts que ejecutan programas en C (`c_program`) para operaciones de bajo nivel.
- Permite configurar todos los parámetros del hardware, iniciar y detener la adquisición, leer resultados y visualizar datos.
- Requiere que el bitstream `lockin_estable.bit` esté cargado en la FPGA, lo cual puede hacerse mediante las funciones de Python o los shell scripts incluidos.

# Flujo de operación
1. Configuración de parámetros por software (control, DAC, lock-in, decimación, triggers).  
2. Selección de fuente de datos y generación de señal (simulada o ADC).  
3. Decimación opcional para visualización.  
4. Procesamiento Lock-in con MAF de `N_ma` ciclos.  
5. Cálculo de salida de R y φ, junto con información de índices y número de muestras promediadas.  
6. Monitoreo de triggers y niveles para sincronización.  
7. Visualización de resultados en LEDs, GPIO o mediante software.  

Este repositorio combina adquisición de datos, procesamiento digital coherente y generación de triggers, siendo ideal para experimentos de control de señales y pruebas de instrumentación con Red Pitaya.
