import numpy as np
import matplotlib
matplotlib.use('Agg')  # Establecer el backend a 'Agg' (sin interfaz gráfica)
import io
import base64
from scipy import signal
import matplotlib.pyplot as plt


def grafico_en_f(f, R, phi):
       
    # Crear la figura para el gráfico de Bode
    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(8, 6), sharex=True)
    
    # Gráfico de magnitud
    ax1.semilogx(f, R, label='Magnitud')
    ax1.set_title('Diagrama de Bode')
    ax1.set_ylabel('Magnitud (dB)')
    ax1.grid(True)
    
    # Gráfico de fase
    ax2.semilogx(f, phi, label='Fase')
    ax2.set_xlabel('Frecuencia (rad/s)')
    ax2.set_ylabel('Fase (radianes)')
    ax2.grid(True)
    
    # Ajustar la disposición
    plt.tight_layout()

    # Guardar la figura en un buffer en memoria
    buffer = io.BytesIO()
    plt.savefig(buffer, format='png', bbox_inches='tight')
    buffer.seek(0)

    # Convertir la imagen en base64
    img_base64 = base64.b64encode(buffer.read()).decode('utf-8')

    # Cerrar la figura para liberar memoria
    plt.close(fig)

    return img_base64

def grafico_adc_as_base64(datos_adc):
    fig, ax = plt.subplots(figsize=(8, 6))
    ax.plot(datos_adc)
    ax.set_title('Gráfico de ADC')
    ax.set_xlabel('Tiempo')
    ax.set_ylabel('Amplitud')

    # Guardar la figura en un buffer en memoria
    buffer = io.BytesIO()
    plt.grid()
    plt.savefig(buffer, format='png')
    buffer.seek(0)

    # Convertir a base64
    img_base64 = base64.b64encode(buffer.read()).decode('utf-8')

    # Cerrar la figura para liberar memoria
    plt.close(fig)

    return img_base64