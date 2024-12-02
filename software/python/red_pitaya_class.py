# -*- coding: utf-8 -*-
"""
Created on Thu Nov 23 12:43:33 2023

Python class to command the Red Pitaya

@author: MatiOliva
"""

import subprocess
import os

from enum import Enum

class DataMode(Enum):
    SIMULACION = 0
    ADC = 1
    
class DecimatorMethod(Enum):
    DISCARD = 0
    PROM = 1

class redP_handler:

    def __init__(self, ip_):
        self.set_N(32)
        self.set_data_mode(DataMode.ADC)
        self.set_IP(ip_)
        self.set_decimator(1)
        self.set_frec_ref(1000000)
        self.set_frec_dac(1000000)
        self.set_decimator_method(DecimatorMethod.DISCARD)
        
        

    def set_IP(self, ip_):
        if self.is_valid_IP(ip_):
            self.ip = ip_
            return True
        return False
    
    def is_valid_IP(self, ip_):
        num_fields = 0
        ip_stream = ip_.split('.')
        for field in ip_stream:
            if not field or len(field) > 3 or not field.isdigit():
                return False

            field_value = int(field)
            if field_value < 0 or field_value > 255:
                return False

            num_fields += 1

        return num_fields == 4
    
    def set_data_mode(self, mode):
        if mode in DataMode:
            self.data_mode = mode.value
            return True
        return False
    
    def set_frec_dac(self,frec):
        self.frec_dac = frec
    
    def set_frec_ref(self,frec):
        self.frec_ref = frec
        
    
    def set_N(self, N):
        if N > 0: 
            self.N = N
            return True
        return False
    
    def set_decimator(self,decimator):
        if decimator > 0:
            self.decimator = decimator;
            return True
        else:
            self.decimator = 1
        return False
    
    def set_decimator_method(self,method):
        if method in DecimatorMethod:
            self.decimator_method = method.value
            return True
        return False
    
    def set_bitstream_in_fpga(self,bitstream_name = "lockin.bit"):
        script_path = os.path.join("..\shell_scripts", ".\set_bitstream.sh")
        command = ( f"{script_path} {bitstream_name} {self.ip}" )
        subprocess.run(command, shell=True)
    
    def measure_lockin(self):
        script_path = os.path.join("..\shell_scripts", ".\lockin.sh")
        command = ( f"{script_path} {self.N} {self.frec_dac} {self.frec_ref} {self.data_mode} {self.decimator} {self.decimator_method} {self.ip}" )
        print(f"Comando enviado a la FPGA: {command}")
        subprocess.run(command, shell=True)
        diccionario = redP_handler.leerArchivoLockin("../datos_adquiridos/resultados.dat");
        diccionario['datos_adc']= redP_handler.leerArchivoADC("../datos_adquiridos/resultados_adc.dat");
        return diccionario
    
    def barrido_ctes_tiempo(self, N_inicial,N_final,iteraciones):
        script_path = os.path.join("..", "shell_scripts", "barrido_ctes_tiempo.sh")
        command = ( f"{script_path} {self.frec_ref} {N_inicial} {N_final} {iteraciones} {self.data_mode} barrido.dat {self.ip}" )
        print(f"Comando enviado a la FPGA: {command}")
        subprocess.run(command, shell=True)
        return redP_handler.leer_archivo_barrido_ctes_tiempo("../datos_adquiridos/barrido.dat")
    
    def barrido_en_frecuencia(self, f_inicial,f_final,f_step,f_dac = 0):
        script_path = os.path.join("..", "shell_scripts", "barrido_en_frecuencia.sh")
        command = ( f"{script_path} {self.N} {f_inicial} {f_final} {f_step} {f_dac} {self.data_mode} barrido_en_f.dat {self.ip}" )
        print(f"Comando enviado a la FPGA: {command}")
        subprocess.run(command, shell=True)
        return redP_handler.leer_archivo_barrido_en_f("../datos_adquiridos/barrido_en_f.dat")
    
    @staticmethod
    def convertir2volt_adc(tension):
        gain_error = 1.131;
        offset_error = -0.015 ;
        medido = (tension)/8192;
        return gain_error*(medido-offset_error);
        
    @staticmethod
    def convertir2volt_lockin(tension):
        medido = (tension)/8192;
        correccion = 508/478; #Medido empiricamente
               
        return (medido*correccion);

    @staticmethod
    def leerArchivoLockin(nombreArchivo):
        diccionario = {}
        with open(nombreArchivo, 'r') as archivo:
            lineas = archivo.readlines()
            if len(lineas) >= 2:
                keys = lineas[0].strip().split(": ")[1].split(",")
                values = lineas[1].strip().split(",")
                for key, value in zip(keys, values):
                    diccionario[key] = float(value)
        return diccionario

    @staticmethod
    def leerArchivoADC(nombre_archivo):
        datos = []
        lineas_leidas=0
        with open(nombre_archivo, 'r') as archivo:
            for linea in archivo:
                lineas_leidas +=1
                if(lineas_leidas > 2):
                    valores = linea.strip().split(', ')
                    for valor in valores:
                        datos.append(int(valor))
        return datos
    
    @staticmethod
    def leer_archivo_barrido_ctes_tiempo(archivo):
        datos = {
            "N": [],
            "mean_r": [],
            "std_r": []
        }
    
        with open(archivo, 'r') as file:
            lines = file.readlines()
    
            # Encontrar la línea donde comienza el bloque de datos
            start_index = None
            for i, line in enumerate(lines):
                if line.startswith("Formato -> N,mean_r,std_r"):
                    start_index = i + 1
                    break
    
            # Leer los datos después del encabezado
            if start_index is not None:
                for line in lines[start_index:]:
                    fila = line.strip().split(',')
                    if len(fila) == 3:
                        datos["N"].append(float(fila[0]))
                        datos["mean_r"].append(float(fila[1]))
                        datos["std_r"].append(float(fila[2]))
    
        return datos
    
    @staticmethod
    def leer_archivo_barrido_en_f(archivo):
        datos = {
            "f": [],
            "r": [],
            "phi": []
        }
    
        with open(archivo, 'r') as file:
            lines = file.readlines()
    
            # Encontrar la línea donde comienza el bloque de datos
            start_index = None
            for i, line in enumerate(lines):
                if line.startswith("Formato -> f,r,phi"):
                    start_index = i + 1
                    break
    
            # Leer los datos después del encabezado
            if start_index is not None:
                for line in lines[start_index:]:
                    fila = line.strip().split(',')
                    if len(fila) == 3:
                        datos["f"].append(float(fila[0]))
                        datos["r"].append(float(fila[1]))
                        datos["phi"].append(float(fila[2]))
    
        return datos

