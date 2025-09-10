# Lock-in en Red Pitaya – Ejecución desde Host  

Este módulo en Python permite controlar la Red Pitaya configurada como **lock-in digital** desde una computadora host. Los scripts disponibles automatizan la configuración, carga de bitstream, ejecución de mediciones y representación gráfica de los resultados.  

## Requisitos  

- Python 3.x  
- Librerías:  
  - matplotlib  
  - numpy  
- Archivos de soporte:  
  - `red_pitaya_class.py` (clase principal de control)  
  - Scripts de shell ubicados en `../shell_scripts/` para comunicación vía SSH.  
- Red Pitaya accesible en la red local mediante su dirección IP.  

## Scripts principales  

### 1. `red_pitaya_class.py`  
Clase central (`redP_handler`) que abstrae el control de la Red Pitaya.  
Permite:  
- Configurar IP y validar conexión.  
- Definir parámetros de medición (fuente de datos, frecuencia de referencia, frecuencia DAC, número de promediaciones N, método de decimación, factor de decimación).  
- Cargar un bitstream en la FPGA (`set_bitstream_in_fpga`).  
- Ejecutar una medición lock-in (`measure_lockin`).  
- Realizar **barrido en constantes de tiempo** y **barrido en frecuencia**.  
- Convertir resultados a voltaje real.  
- Leer archivos de resultados (`resultados.dat`, `resultados_adc.dat`, barrido.dat).  

### 2. `ejecutar_lockin.py`  
Ejemplo de uso básico.  
- Configura la IP y parámetros de medición.  
- Carga opcional del bitstream (solo la primera vez).  
- Ejecuta una medición lock-in.  
- Muestra los resultados:  
  - Amplitud (`R`) convertida a voltios.  
  - Fase (`phi`).  
- Permite graficar los datos adquiridos del ADC.  

### 3. `barrido_ctes_tiempo.py`  
Realiza un **barrido de constantes de tiempo**.  
- Configura modo de datos, método de decimación y frecuencias.  
- Define un rango de N (ej. de 1 a 4096) y cantidad de iteraciones por valor.  
- Ejecuta el barrido en la Red Pitaya.  
- Devuelve medias y desviaciones estándar de la magnitud (`r`).  
- Grafica `std_r` en función de `N`.  

### 4. `barrido_en_frecuencia.py`  
Realiza un **barrido en frecuencia**.  
- Configura parámetros de lock-in (N, decimador, método de decimación).  
- Define rango de frecuencias (`f_inicial`, `f_final`, `f_step`).  
- Ejecuta el barrido y obtiene magnitud (`r`) y fase (`phi`).  
- Calcula automáticamente la **frecuencia de corte** como el punto donde la fase es ≈ -45°.  
- Grafica:  
  - `f vs r` (respuesta en magnitud).  
  - `f vs phi` (respuesta en fase).  
  - Incluye línea vertical y etiqueta de la frecuencia de corte.  

## Flujo típico de operación  

1. Ajustar la **IP** de la Red Pitaya en los scripts.  
2. (Opcional) cargar el **bitstream** en la FPGA si aún no está configurado.  
3. Definir parámetros de medición (N, decimador, frecuencias).  
4. Ejecutar el script correspondiente:  
   - `ejecutar_lockin.py` → una medición puntual.  
   - `barrido_ctes_tiempo.py` → exploración de promediaciones.  
   - `barrido_en_frecuencia.py` → análisis de respuesta en frecuencia.  
5. Visualizar los resultados en consola y en gráficos de matplotlib.  

## Observaciones  

- La carga del bitstream suele hacerse solo una vez; los siguientes usos no requieren repetirla.  
- Los datos adquiridos se guardan en `../datos_adquiridos/`.  
- Los métodos de decimación disponibles son **DISCARD** (descartar) y **PROM** (promediado).  
- El sistema está pensado para análisis de señales en tiempo real con referencia interna configurada desde el host.  
