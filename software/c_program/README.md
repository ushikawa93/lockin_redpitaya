# FPGA Lock-In Measurement Suite

Esta carpeta contiene una serie de programas en C diseñados para ejecutarse en el **micro de la FPGA (Red Pitaya u otra plataforma compatible)**.  

Los programas permiten configurar y controlar el lock-in implementado en hardware, realizar barridos sobre parámetros de interés y analizar el ruido de las mediciones.

Para que todo ande correctamente la Red Pitaya debe estar cargada con el bitstream lockin_estable.bit. Esto puede hacerse a través de un shell script disponible en ../shell_scripts.

---

## Programas incluidos

### 1. `lockin.c`
Programa principal para interactuar con el lock-in digital en la FPGA.  
Permite fijar parámetros de operación como la constante de tiempo, número de muestras por ciclo, frecuencias de referencia/DAC, método de decimación y fuente de datos (simulación o ADC).  

**Uso:**  
lockin N_ma frec_dac frec_ref fuente decimator decimator_method  

**Parámetros:**
- `N_ma`: Constante de tiempo (ciclos de integración)  
- `frec_dac`: Frecuencia del DAC (Hz)  
- `frec_ref`: Frecuencia de referencia (Hz)  
- `fuente`: 0 = SIM, 1 = ADC  
- `decimator`: Factor de decimación  
- `decimator_method`: 0 = normal, 1 = promediación lineal  

**Salida:**
- Resultados en consola (fase, cuadratura, amplitud y ángulo)  
- `resultados.dat` con f, M, N, r, phi  
- `resultados_adc.dat` con los valores crudos del ADC  

---

### 2. `barrido_ctes_tiempo.c`
Script para realizar un **barrido en N (constante de tiempo)** y estimar el ruido asociado.  
Automatiza la ejecución del lock-in para un rango de valores de N y varias iteraciones por cada configuración.

**Uso:**  
barrido_ctes_tiempo frec N_inicial N_final iteraciones fuente archivo_salida  

**Parámetros:**
- `frec`: Frecuencia de referencia (Hz)  
- `N_inicial`: Valor inicial de N  
- `N_final`: Valor final de N (no inclusivo)  
- `iteraciones`: Número de repeticiones por cada N  
- `fuente`: 0 = SIM, 1 = ADC  
- `archivo_salida`: Nombre del archivo CSV de salida  

**Salida:**
- Archivo con columnas: `N, mean_r, std_r`  

---

### 3. `medir_error.c`
Script orientado a medir el error estadístico del lock-in en distintas condiciones de N y frecuencia.  
Ejecuta múltiples iteraciones, calcula la media y desviación estándar de la amplitud en voltios, y guarda los resultados en un archivo.

**Uso:**  
medir_error N frecuencia n_iteraciones fuente nombre_archivo_salida  

**Parámetros:**
- `N`: Constante de tiempo (ciclos de integración)  
- `frecuencia`: Frecuencia de referencia y DAC (Hz)  
- `n_iteraciones`: Número de repeticiones  
- `fuente`: 0 = SIM, 1 = ADC  
- `nombre_archivo_salida`: Archivo donde se guardan los resultados  

**Salida:**
- Archivo de texto con media y desviación estándar de r (en mV)  
- Resultados intermedios mostrados por consola  

---

## Requisitos
- FPGA con lock-in digital implementado  
- Acceso a `/dev/mem` (ejecutar con permisos de superusuario)  
- Compilador C estándar (gcc recomendado)  

---

## Notas
- La frecuencia de muestreo se asume en **125 MHz**  
- El mapeo de direcciones a registros de la FPGA está definido mediante `#define` en cada archivo  
- Los scripts son independientes pero comparten estructura y funciones auxiliares comunes (reset, configuración de registros, lectura de resultados, manejo de archivos)  
- Se recomienda compilar cada programa por separado y ejecutarlos desde la FPGA  

