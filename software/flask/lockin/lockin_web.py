""" ------------------------------------------- """
""" ---------- IMPORTO ALGUNAS COSAS ---------- """
""" ------------------------------------------- """   

from flask import Flask, render_template,  jsonify, request
from graficos import grafico_adc_as_base64, grafico_en_f
import socket
import shutil

import os,sys
sys.path.append(os.path.abspath('../red_pitaya_python'))
from lockin_functions import lockin  
from resultado_lockin import CondicionesMedicion,FuenteDatos,ModoDecimacion,ResultadoLockin;

from adquisidor_functions import adquisidor
from condiciones_adquisicion import TriggerMode,CondicionesAdquisicion;
import math;
import time;

""" ------------------------------------------- """
""" -------- Funciones auxiliares ------------- """
""" ------------------------------------------- """  

def reiniciar_notebooks():
    ruta_origen = "../red_pitaya_python/lockin_notebook_original.ipynb"
    ruta_destino = "../red_pitaya_python/lockin_notebook.ipynb"
    shutil.copy(ruta_origen, ruta_destino)

    ruta_origen = "../red_pitaya_python/adquisidor_notebook_original.ipynb"
    ruta_destino = "../red_pitaya_python/adquisidor_notebook.ipynb"
    shutil.copy(ruta_origen, ruta_destino)    


def barrido_en_f(f_inicial, f_final, f_step, N, fuente_datos):
    r = []
    phi = []
    frecuencias = range(f_inicial, f_final + 1, f_step)

    for f in frecuencias:
        condicionesMedicion = CondicionesMedicion(
            frec_ref=f, 
            frec_dac=f, 
            N=int(request.form['N_barrido']), 
            fuente_datos=FuenteDatos(int(request.form['fuente_barrido'])), 
            modo_decimacion=ModoDecimacion(0), 
            decimador=1
        )
        resultado = lockin.MedirLockin(condicionesMedicion)
        r.append(resultado.get_R())  # Agregar el resultado al arreglo
        phi.append(resultado.get_phi())

    # Normalización de r
    max_r = max(r) if r else 1  # Evita dividir por cero si la lista está vacía
    r_normalizado = [valor / max_r for valor in r]    
    return frecuencias, r_normalizado, phi

def obtener_ip_jupyter():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        # No se conecta realmente, pero fuerza la detección de la IP local.
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
    finally:
        s.close()
    return ip



""" ------------------------------------------- """
""" ---------- APLICACIÓN FLASK --------------- """
""" ------------------------------------------- """   


app = Flask(__name__, static_url_path='/static/')
app.config['SEND_FILE_MAX_AGE_DEFAULT'] = 10000
@app.route('/', methods=['GET', 'POST'])


def index():

    # SOLICITUD GET,SOLO PRIMERA VEZ QUE SE ABRE LA APP
    if(request.method == 'GET'):
        datos = {'r':"-",'phi':"-",'ip':obtener_ip_jupyter() }
        lockin.set_fpga()
        reiniciar_notebooks()
        return render_template('index_lockin_bootstrap.html', datos = datos, tab="tab1")
   
    # SOLICITUD POST DE INICIAR LOCKIN
    if (request.method == 'POST') and (request.form['submit_button'] == 'Iniciar Medidas'):
        lockin.set_fpga()

        condicionesMedicion = CondicionesMedicion( frec_ref=int(request.form['f_ref']), 
            frec_dac=int(request.form['f_dac']), 
            N=int(request.form['N']), 
            fuente_datos=FuenteDatos(int(request.form['fuente'])), 
            modo_decimacion=ModoDecimacion(int(request.form['modo_dec'])), 
            decimador=int(request.form['valor_decimacion']) )
            
        # Resultados del Lockin
        resultado = lockin.MedirLockin(condicionesMedicion)
        graficar = True if (request.form['graph'] == "1" ) else False; 

        K = 1 if (ModoDecimacion(int(request.form['modo_dec'])) == 0) else int(request.form['valor_decimacion']) 

        datos_adc = lockin.leer_adc(reset=False,K=K) if graficar else {}
        img = grafico_adc_as_base64(datos_adc) if graficar else {}
        
        datos ={'r': round(resultado.get_R() * 1000, 4),
            'phi': round(resultado.get_phi() * 180 / math.pi,3) ,
            'frec_ref': resultado.condiciones.get_Frec_ref(),
            'frec_dac': resultado.condiciones.get_Frec_dac(),
            'N': resultado.condiciones.get_N(),
            'fuente_datos': str(resultado.condiciones.get_Fuente_datos()),  # <-- Conversión a string
            'modo_decimacion': str(resultado.condiciones.get_Modo_decimacion()),  # <-- Conversión a string
            'decimador': resultado.condiciones.get_Decimador(),
            'graficar' : str(graficar),
            'datos_adc':datos_adc,
            'ip':obtener_ip_jupyter() }       
        
        return render_template('index_lockin_bootstrap.html', imagen=img , datos=datos , tab="lockin")
        
    # SOLICITUD POST DE BARRIDO EN FRECUENCIA
    if (request.method == 'POST') and (request.form['submit_button'] == 'Iniciar Barrido'):
        lockin.set_fpga()

        f,R,phi = barrido_en_f( int (request.form['f_inicial']), 
                                int (request.form['f_final']),
                                int(request.form['f_step']), 
                                int(request.form['N_barrido']),
                                FuenteDatos(int(request.form['fuente_barrido'])))
            
        datos = {'f_inicial': request.form['f_inicial'],
                'f_final': request.form['f_final'],
                'f_step' :request.form['f_step'],
                'N_barrido' :request.form['N_barrido'],
                'fuente_barrido':FuenteDatos(int(request.form['fuente_barrido'])).value,
                'frecuencias':list(f),
                'amplitudes':R,
                'fases':phi,
                'ip':obtener_ip_jupyter() }
        
        img = grafico_en_f( f, R, phi ) 

        return render_template('index_lockin_bootstrap.html',imagen_barrido=img ,datos=datos, tab="barrido")
    
    # SOLICITUD POST DE ADQUISIDOR
    if (request.method == 'POST') and (request.form['submit_button'] == 'Iniciar adquisición'):
        tiempos = {}

        t0 = time.perf_counter()
        adquisidor.set_fpga()
        tiempos["set_fpga"] = time.perf_counter() - t0

        t1 = time.perf_counter()
        ch_a, ch_b = adquisidor.adquirir(CondicionesAdquisicion(
            N_ca=int(request.form['N_ca']),
            frec_objetivo=int(request.form['frec_ca']),
            trigger_mode=TriggerMode(int(request.form['trig_mode'])),
            trigger_level=int(request.form['trig_lvl'])
        ))
        tiempos["adquirir"] = time.perf_counter() - t1

        t2 = time.perf_counter()
        img_a = grafico_adc_as_base64(ch_a)
        img_b = grafico_adc_as_base64(ch_b)
        tiempos["generar_imagen"] = time.perf_counter() - t2

        datos = {
            'datos_ch_a': ch_a,
            'datos_ch_b': ch_b,
            'N_ca': int(request.form['N_ca']),
            'frec_ca': int(request.form['frec_ca']),
            'trig_mode': int(request.form['trig_mode']),
            'trig_lvl': int(request.form['trig_lvl']),
            'tiempos': tiempos,  # Guardamos los tiempos para inspección
            'ip':obtener_ip_jupyter() 
        }

        return render_template('index_lockin_bootstrap.html', imagen_adquisidor_a=img_a, imagen_adquisidor_b=img_b, datos=datos, tab="adquisidor")




if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

