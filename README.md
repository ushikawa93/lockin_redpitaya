# lockin_redpitaya
Detección Lockin usando Red Pitaya

# Carpeta Hardware
Hardware de la FPGA. Está armado con un "block diagram" que tiene componentes propios y algunas IP de Xilinx.
Los módulos principales son:

+ *Control:* Controla la operación de la FPGA a través  del uP embebido. Puede controlar reset, enable, leer resultados y setear algunos parámetros:
 
  - N_ma: Número de ciclos promedidados en el MA del lockin

  - data_source: Fuente de los datos. (0: simulacion | 1: ADC)

  - dac_phase: Incremento de fase para el dds del dac

  - ref_phase: Incremento de fase para el dds de las referencias

  - decimate_value: Valor de decimación.

  - decimate_mode: Modo de decimacion (0: descarte | 1: promedio lineal)

  - M: Puntos por ciclo de señal. En la última versión se usa DDS para generar la sinusoide asique esto solo se usa para estimar el punto de paso por cero de la secuencia.

+ *Fuente de datos:* Este módulo gestiona las señales para el procesamiento. Puede ser una señal simulada o datos provenientes del ADC. 

+ *Decimador:* Para reducir el número de datos que entran a las memorias se puede decimar la señal entrante (ya sea la del ADC o la de la simulacion).
Esto es solo para visualizarla, al lockin entra siempre la señal entera.

+ *Lockin:* Hace Lockin con MAF de Nma ciclos sobre la señal. Saca las componentes X e Y. Despues el uP calcula el R y el phi como R=sqrt(X^2+Y^2) y phi=atan(Y/X).
Una salida extra "datos_promedidos" determina cuantas muestras tiene realmente el resultado calculado.

+ *DAC:* Contola el DAC generando una señal sinusoidal a través de un dds compiler y el parámetro dac_phase.

# Carpeta Software
Controla la operación del lockin. Pueden usarse directamente las funciones de Python.

Estas se valen de los shell_scripts, que controla a través de ssh al SoC, y ejecuta funciones escritas en c disponibles en la carpeta c_program.

Para que la cosa ande bien tiene que estar configurado el bitstream lockin_estable.bit en la FPGA (Hay una funcion de python; y un shell_script que lo programa).

