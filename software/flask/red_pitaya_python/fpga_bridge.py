"""
========================================================================
Módulo de comunicación y control de FPGA a bajo nivel
========================================================================

Descripción:
------------
Este módulo proporciona la clase FPGA y funciones asociadas para:
1. Mapear la memoria de la FPGA en el espacio de usuario de Linux.
2. Leer y escribir en direcciones específicas de memoria (MMIO).
3. Cargar bitstreams en la FPGA de forma segura, evitando recargas innecesarias.
4. Controlar dispositivos FPGA desde Python para aplicaciones de adquisición
   y lock-in.

Clase FPGA:
-----------
- __init__(): inicializa el mapeo de memoria de la FPGA.
- read_from_address(address): lee un valor de 32 bits desde una dirección específica.
- write_in_address(address, value): escribe un valor de 32 bits en una dirección específica.
- close(): libera recursos de memoria y archivo.
- __del__(): asegura el cierre de recursos al destruir el objeto.
- set_fpga_bitstream(name='fpga.bit'): carga un bitstream en la FPGA y registra la versión.

Funciones auxiliares:
--------------------
- setup_memory(): mapea la memoria de la FPGA y devuelve un puntero y descriptor de archivo.

Constantes:
-----------
- START_ADDRESS: dirección base de memoria de la FPGA.
- MEMORY_SIZE: tamaño del espacio mapeado.
- device_name: ruta al dispositivo /dev/mem.
- VERSION_FILE: archivo que registra la versión cargada del bitstream.

Notas:
------
- El módulo permite operaciones de lectura/escritura alineadas a 4 bytes.
- Cualquier intento de acceso fuera del rango mapeado o no alineado genera error.
- La función set_fpga_bitstream evita recargar un bitstream ya activo para
  optimizar tiempos.
- Ideal para usarse junto con módulos de adquisición y lock-in que requieren
  acceso directo a registros de FPGA desde Python.

Dependencias:
-------------
- os, mmap, ctypes, time, shutil, pathlib
"""


import os
import mmap
import ctypes
import time 
import shutil
from pathlib import Path

START_ADDRESS = 0x40000000
MEMORY_SIZE = 0x4000000
device_name = "/dev/mem"
VERSION_FILE = "/run/fpga_version"

def setup_memory():
    fd = os.open(device_name, os.O_RDWR | os.O_SYNC)
    if fd < 0:
        raise RuntimeError("No se pudo abrir el dispositivo")
    
    cfg = mmap.mmap(fd, MEMORY_SIZE, mmap.MAP_SHARED, mmap.PROT_READ | mmap.PROT_WRITE, offset=START_ADDRESS)
    cfg_ptr = ctypes.addressof(ctypes.c_char.from_buffer(cfg))
    
    return cfg, cfg_ptr, fd

class FPGA:

    def __init__(self):
        self.cfg, self.cfg_ptr, self.fd = setup_memory()
        pass


    def read_from_address(self,address):
        try:
            offset = address - START_ADDRESS
            if offset < 0 or offset >= MEMORY_SIZE:
                raise ValueError("La dirección está fuera del rango mapeado")
            if address % 4 != 0:
                raise ValueError("La dirección no está alineada a 4 bytes")
            return ctypes.c_uint32.from_address(self.cfg_ptr + offset).value
        except Exception as e:
            print("Error:", e)
        

    def write_in_address(self,address, value):
        try:
            offset = address - START_ADDRESS
            if offset < 0 or offset >= MEMORY_SIZE:
                raise ValueError("La dirección está fuera del rango mapeado")
            ctypes.cast(self.cfg_ptr + offset, ctypes.POINTER(ctypes.c_uint32)).contents.value = value
        except Exception as e:
            print("Error:", e)

    def close(self):
        if self.cfg is not None:
            self.cfg.close()
            self.cfg = None
        if self.fd is not None:
            os.close(self.fd)
            self.fd = None

    def __del__(self):
        self.close()
    
    @staticmethod
    def set_fpga_bitstream(name='fpga.bit'):
        expected_version = name

        # Verificar si la versión ya está registrada
        if os.path.exists(VERSION_FILE):
            with open(VERSION_FILE, 'r') as f:
                loaded_version = f.read().strip()
            if loaded_version == expected_version:
                print("El bitstream '{}' ya está cargado.".format(name))
                return

        # Cargar el bitstream
        source_path = Path("../fpga/{}".format(name))
        destination_path = Path("../fpga/fpga.bit")

        shutil.copy(str(source_path), str(destination_path))
        with open(str(destination_path), 'rb') as src, open('/dev/xdevcfg', 'wb') as dev:
            dev.write(src.read())

        # Registrar la versión cargada
        with open(VERSION_FILE, 'w') as f:
            f.write(expected_version)

        print("Bitstream '{}' cargado correctamente.".format(name))



if __name__ == "__main__":
    N_DATOS_PROMEDIADOS_ADDRESS = 0x41270000
    ENABLE_ADDRESS = 0x41230000
    RESET_ADDRESS = 0x41230008
    FINISH_ADDRESS = 0x41210000

    FPGA.set_fpga_bitstream("lockin_estable.bit")
    fpga = FPGA()

    fpga.write_in_address(ENABLE_ADDRESS,0)
    
    fpga.write_in_address(RESET_ADDRESS,0)
    
    fpga.write_in_address(RESET_ADDRESS,1)
    
    fpga.write_in_address(ENABLE_ADDRESS,1)

    while (fpga.read_from_address(FINISH_ADDRESS) == 0):
         time.sleep(0.001)

    value = fpga.read_from_address(N_DATOS_PROMEDIADOS_ADDRESS)
    print(value)

  
