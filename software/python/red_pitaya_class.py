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

class redP_handler:

    def __init__(self, ip_):
        self.set_N(32)
        self.set_M(32)
        self.set_data_mode(DataMode.ADC)
        self.set_IP(ip_)
        self.set_noise_bits(0)

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
    
    def set_M(self, M):
        if M > 4 and M <= 2048: 
            self.M = M
            return True
        return False
    
    def set_N(self, N):
        if N > 0 and N <= 4096: 
            self.N = N
            return True
        return False
    
    def set_noise_bits(self, noise_b):
        if noise_b >= 0 and noise_b <= 32: 
            self.noise_b = noise_b
            return True
        return False

    def set_bitstream_in_fpga(self,bitstream_name = "lockin.bit"):
        script_path = os.path.join("..\shell_scripts", ".\set_bitstream.sh")
        command = ( f"{script_path} {bitstream_name} {self.ip}" )
        subprocess.run(command, shell=True)
    
    def measure_lockin(self):
        script_path = os.path.join("..\shell_scripts", ".\lockin.sh")
        command = ( f"{script_path} {self.N} {self.M} {self.noise_b} {self.data_mode} {self.ip}" )
        print(f"Comando enviado a la FPGA: {command}")
        subprocess.run(command, shell=True,check=True)
        return redP_handler.leerArchivoLockin("../datos_adquiridos/resultados.dat")
        
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

