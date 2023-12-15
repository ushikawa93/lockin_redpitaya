# -*- coding: utf-8 -*-
"""
Created on Thu Nov 23 12:43:33 2023

Python class to command the Red Pitaya

@author: MatiOliva
"""

from math import log2
from math import ceil
import subprocess
import os
import re

from enum import Enum

class TriggerMode(Enum):
    DISPARO_CONTINUO = 0
    DISPARO_NIVEL = 1
    DISPARO_EXTERNO = 2

class redP_handler:


    def __init__(self, ip_):
        self.frecuencia_clock = 125000000
        self.tam_buffer = 30720        
        self.ciclos_promediacion = 1
        self.trigger_mode = 2
        self.trigger_level = 0        
        self.num_archivo = 0
        self.archivo_destino_base = "test"
        self.adc_threshold = 8191
        self.set_IP(ip_)
        self.set_frec_objetivo(10)

    def check_limits(self):
        return (log2(self.ciclos_promediacion) + log2(self.factor_sobremuestreo) - self.log2_divisor + 14) > 32


    def set_divisor(self):
        self.log2_divisor = 0
        while self.check_limits():
            self.log2_divisor += 1

    def set_DAC_frec(self, value):
        if 0 < value < 20000000:
            self.frec_dac = value

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

    def set_bitstream_in_fpga(self):
        script_path = os.path.join("shell_scripts", "set_bitstream.sh")
        command = ( f"{script_path}  adquisidor_ca.bit {self.ip}" )
        subprocess.run(command, shell=True)

    def set_trigger_mode(self, mode):
        if mode in TriggerMode:
            self.trigger_mode = mode.value
            return True
        return False

    def set_trigger_level(self, level):
        if -8192 < level < 8192:
            self.trigger_level = level
            return True
        return False

    def set_IP(self, ip_):
        if self.is_valid_IP(ip_):
            self.ip = ip_
            return True
        return False

    def set_sobremuestreo(self, K):
        if K > 0:
            self.factor_sobremuestreo = ceil(K)
            self.set_divisor()
            return True
        return False

    def set_prom_coherente(self, Nca):
        if Nca > 0:
            self.ciclos_promediacion = Nca
            self.set_divisor()
            return True
        return False

    def set_frec_objetivo(self, frec_objetivo):
        if frec_objetivo > 0:
            self.frec_obj = frec_objetivo
            self.set_sobremuestreo(self.frecuencia_clock / (self.tam_buffer * self.frec_obj))
            self.set_DAC_frec(self.frec_obj)
            return True
        return False

    def get_frec_muestreo(self):
        return self.frecuencia_clock / self.factor_sobremuestreo

    def get_archivo_destino(self):
        return f"{self.archivo_destino_base}_{self.num_archivo}.dat"

    def set_nombre_archivo_base(self, nombre):
        self.num_archivo = 0
        self.archivo_destino_base = nombre

    def inc_archivo(self):
        self.num_archivo += 1

    def set_threshold(self, value):
        script_path = os.path.join("shell_scripts", "set_adc_threshold.sh")
        if -8192 < value < 8192:
            self.adc_threshold = value
            command = (f"{script_path} {self.adc_threshold} {self.ip}")
            print(f"Comando enviado a FPGA: {command}")
            subprocess.run(command, shell=True)
            return True
        return False

    def get_modo_disparo(self):
        if self.trigger_mode == 0:
            return "Disparo continuo"
        if self.trigger_mode == 1:
            return f"Disparo por nivel del canal 1 configurado en: {self.trigger_level} Cuentas"
        if self.trigger_mode == 2:
            return "Disparo externo"
        return "error"


    def adquirir(self):
        script_path = os.path.join("shell_scripts", "adquirir.sh")
        command = (
            f"{script_path} {self.factor_sobremuestreo} {self.ciclos_promediacion} {self.get_archivo_destino()} "
            f"{self.tam_buffer} {self.frec_dac} {self.trigger_mode} {self.trigger_level} {self.log2_divisor} {self.ip}"
        )
        print(f"Comando enviado a FPGA: {command}")
        subprocess.run(command, shell=True)
        self.inc_archivo()

    def get_estado(self):
        state = f"Adquisidor Red Pitaya en IP: {self.ip}\n" \
                f"Threshold del ADC: {self.adc_threshold} (Aproximadamente {self.adc_threshold / 8192} mV)\n" \
                f"Archivo de destino: {self.get_archivo_destino()}\n" \
                f"Frecuencia de muestreo: {self.get_frec_muestreo()} " \
                f"(CLK:125 MHz / Sobremuestreo: {self.factor_sobremuestreo})\n" \
                f"Configurado para señales de: {self.frec_obj} Hz\n" \
                f"Modo de disparo: {self.get_modo_disparo()}\n" \
                f"Ciclos de promediación coherente (Nca): {self.ciclos_promediacion}\n"

        return state
 
    @staticmethod
    def leer_archivo(nombre_archivo):
        # Inicializa la lista 'data'
        data = []
        metadata = []
        i = 0
    
        with open(nombre_archivo, 'r') as archivo:
            metadata_info =  re.search(r'Frecuencia_de_muestreo: (\d+) Factor_de_sobremuestreo: (\d+) Ciclos_de_promediacion: (\d+) Divisor: (\d+)',archivo.read())
            if metadata_info:
                metadata.append(int(metadata_info.group(1)))
                metadata.append(int(metadata_info.group(2)))
                metadata.append(int(metadata_info.group(3)))
                metadata.append(int(metadata_info.group(4)))
                
        with open(nombre_archivo, 'r') as archivo:
            for line in archivo:                
                if (i == 2) or (i == 4) or (i == 6):
                    currentline = [int(valor) if valor.strip() else 0 for valor in line.strip().split(",")]
                    data.append(currentline)
                i += 1

        return data,metadata
