# Interfaz Web para Medición Lock-in con FPGA

Este repositorio contiene una aplicación web desarrollada en Python utilizando **Flask** para controlar y visualizar mediciones de un lock-in amplifier implementado en FPGA, así como para adquirir datos del ADC con promediación coherente o lineal. La interfaz permite ejecutar mediciones individuales, realizar barridos en frecuencia y adquirir señales completas desde la FPGA.

---

## Estructura de Archivos

- Carpeta lockin: 
   - **lockin_web.py**: Aplicación principal de Flask que define las rutas y maneja las solicitudes GET y POST para las diferentes funciones del lock-in y adquisidor.
   - **graficos.py**: Funciones para generar gráficos de resultados (Bode y datos de ADC) y convertirlos a imágenes base64 para mostrar en la interfaz web.

- Carpeta red_pitaya_python:
   - **adquisidor_functions.py**: Clase `adquisidor` que permite controlar la adquisición de señales desde la FPGA con promediación coherente.
   - **condiciones_adquisicion.py**: Clases `CondicionesAdquisicion` y enumeración `TriggerMode` que definen los parámetros de adquisición (frecuencia, cantidad de muestras, modo de disparo, etc.).
   - **fpga_bridge.py**: Clase `FPGA` para mapear la memoria de la FPGA y leer/escribir en direcciones específicas, así como para cargar bitstreams.
   - **lockin_functions.py**: Clase `lockin` para configurar y medir el lock-in amplifier en la FPGA, incluyendo configuración de frecuencias, decimador y fuente de datos.
   - **resultado_lockin.py**: Clases `CondicionesMedicion`, `FuenteDatos`, `ModoDecimacion` y `ResultadoLockin` que definen los parámetros de medición y almacenan los resultados de las mediciones.

---

## Requisitos

- Python 3.8 o superior
- Flask
- NumPy
- SciPy
- Matplotlib
- Acceso a la memoria `/dev/mem` para controlar la FPGA
- Bitstreams para FPGA: `lockin_estable.bit` y `adquisidor_experimental.bit`

---

## Ejecución de la Interfaz

1. **Iniciar la aplicación Flask:**

   Ejecutar `app.py` directamente:

       python app.py

   La aplicación escuchará en `http://0.0.0.0:5000`.

2. **Acceso desde navegador:**

   Ingresar la IP de la computadora donde corre Flask (o `localhost`) y puerto 5000.

3. **Funciones principales de la interfaz:**

   - **Lock-in Individual:**
     Permite configurar la frecuencia de referencia (`f_ref`), frecuencia DAC (`f_dac`), número de muestras (`N`), fuente de datos (`SIM` o `ADC`) y modo de decimación (`Descartar` o `Promedio lineal`). Devuelve los resultados `r` y `phi` y, opcionalmente, el gráfico de la señal adquirida.

   - **Barrido en frecuencia:**
     Realiza mediciones en un rango de frecuencias definido por el usuario (`f_inicial`, `f_final`, `f_step`) y grafica la magnitud y fase de la señal en un diagrama de Bode.

   - **Adquisidor de Señal:**
     Permite adquirir los datos completos del ADC en los canales A y B con parámetros configurables: número de muestras (`N_ca`), frecuencia objetivo (`frec_ca`), modo de trigger (`trig_mode`) y nivel de disparo (`trig_lvl`). Los resultados se muestran en gráficos de tiempo.

---

## Clases Principales

### Lock-in

- `lockin.set_fpga(name="lockin_estable.bit")` – Carga el bitstream correspondiente.
- `lockin.MedirLockin(condiciones)` – Realiza la medición y devuelve un objeto `ResultadoLockin`.
- `lockin.leer_adc(reset=True, K=1)` – Devuelve los datos del ADC como lista de voltajes.

### ResultadoLockin

- `x`, `y` – Valores internos de la medición.
- `r`, `phi` – Magnitud y fase calculadas.
- `condiciones` – Objeto `CondicionesMedicion` con parámetros de la medición.

### Adquisidor

- `adquisidor.set_fpga(name="adquisidor_experimental.bit")` – Carga el bitstream de adquisición.
- `adquisidor.adquirir(condiciones)` – Realiza la adquisición según `CondicionesAdquisicion`.

### Condiciones de Medición y Adquisición

- `CondicionesMedicion` – Parámetros para medición lock-in.
- `CondicionesAdquisicion` – Parámetros para adquisición de señales (N_ca, frecuencia, trigger, etc.).
- `FuenteDatos` – Enum: `SIM` o `ADC`.
- `ModoDecimacion` – Enum: `DISCARD` o `PROM`.
- `TriggerMode` – Enum: `CONTINUO`, `NIVEL`, `EXTERNO`.

---

## Uso General

1. Configurar la FPGA con el bitstream adecuado (`lockin_estable.bit` o `adquisidor_experimental.bit`).
2. Definir las condiciones de medición o adquisición.
3. Ejecutar la medición con `lockin.MedirLockin()` o `adquisidor.adquirir()`.
4. Visualizar resultados en la interfaz web con gráficos generados por `graficos.py`.
5. Guardar o exportar datos según sea necesario.

---

## Notas

- La interfaz maneja internamente la conversión de los datos en complemento a 2 a voltaje real.
- Los gráficos se generan en memoria y se muestran como imágenes en base64 para integración directa en la web.
- Los tiempos de adquisición y procesamiento se registran para monitoreo y depuración.
- Requiere permisos de administrador para acceder a `/dev/mem` y escribir en `/dev/xdevcfg`.

---

## Autores

- Matias Oliva

---

## Licencia

- Proyecto de uso personal/interno. Adaptable para uso académico o experimental.
