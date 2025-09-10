"""
========================================================================
Módulo de definición de condiciones de adquisición y modos de trigger
========================================================================

Descripción:
------------
Este módulo define las estructuras de datos y enumeraciones necesarias
para configurar un sistema de adquisición de señales en FPGA. Proporciona:

1. Enumeración 'TriggerMode':
   - Define los modos de disparo disponibles:
     * CONTINUO: disparo continuo
     * NIVEL: disparo por nivel
     * EXTERNO: disparo externo
   - Implementa un método __str__ para obtener la descripción legible.

2. Clase 'CondicionesAdquisicion':
   - Representa los parámetros de configuración para la adquisición de señales.
   - Calcula automáticamente parámetros derivados como:
     * K: factor de sobremuestreo lineal
     * M: número de muestras por ciclo
     * log2_divisor: divisor para decimación coherente
   - Incluye getters para acceder a todos los parámetros importantes.
   - Ajusta la frecuencia real usada en la FPGA según la limitación del DDS compiler.
   - Permite inicialización con valores por defecto, ajustables por el usuario.

Parámetros por defecto:
----------------------
- Frecuencia de muestreo del sistema: 125 MHz
- N_ca: 100
- Frecuencia objetivo del DAC: 1 MHz
- Modo de disparo: NIVEL
- Nivel de disparo: 0
- Tamaño de buffer interno: 30000 muestras

Dependencias:
-------------
- math
- enum (Enum)

Notas:
------
- La clase asegura que los parámetros cumplen con los límites de la FPGA
  y ajusta automáticamente el divisor log2 necesario.
- Ideal para usar junto con el módulo adquisidor_functions.py para configurar
  y ejecutar adquisiciones coherentes en la FPGA.
"""


from enum import Enum
import math

""" ------------------------------------------------------- """
""" ------------ Enumeraciones auxiliares ----------------- """
""" ------------------------------------------------------- """  
class TriggerMode(Enum):
    CONTINUO = 0
    NIVEL = 1
    EXTERNO = 2

    def __str__(self):
        if (self == TriggerMode.CONTINUO):
            return "Disparo continuo"
        elif (self == TriggerMode.NIVEL):
            return "Disparo por nivel"
        elif (self == TriggerMode.EXTERNO):
            return "Disparo externo"

""" ------------------------------------------------------- """
""" ------- Clase para Condicones de adquisicion ---------- """
""" ------------------------------------------------------- """  

class CondicionesAdquisicion:
    # Valores por defecto
    _FS = 125000000
    _N_CA_DEFAULT = 100
    _FREC_DAC_DEFAULT = 1000000
    _TRIGGER_MODE_DEFAULT = TriggerMode.NIVEL
    _TRIGGER_LEVEL_DEFAULT = 0
    _TAM_BUFFER = 30000 

    def __init__(self, 
                 N_ca=None,
                 frec_objetivo=None,
                 trigger_mode=None, 
                 trigger_level=None):

        # Estas cosas la setea el usuario, las otras K y Divisor las saco según f_objetivo y tam_buffer
        self.N_ca = N_ca if N_ca is not None else self._N_CA_DEFAULT
        self.frec_objetivo = frec_objetivo if frec_objetivo is not None else self._FREC_DAC_DEFAULT        
        self.trigger_mode = trigger_mode if trigger_mode is not None else self._TRIGGER_MODE_DEFAULT
        self.trigger_level = trigger_level if trigger_level is not None else self._TRIGGER_LEVEL_DEFAULT

        self.frec_objetivo = CondicionesAdquisicion.FrecuenciaReal(self.frec_objetivo)

        self.K = math.ceil(self._FS/ (self._TAM_BUFFER * self.frec_objetivo))
        self.set_divisor()
        self.M = math.floor( self._FS / ( self.K * self.frec_objetivo ) )

    # Getters
    def get_N_ca(self):
        return self.N_ca
    
    def get_f_muestreo(self):
        return self._FS / self.K

    def get_frec_objetivo(self):
        return self.frec_objetivo

    def get_M(self):
        return self.M

    def get_K(self):
        return self.K

    def get_Log2_divisor(self):
        return self.log2_divisor

    def get_Trigger_mode(self):
        return self.trigger_mode

    def get_Trigger_level(self):
        return self.trigger_level

    def __str__(self):
        return ("N_ca={}, frec_dac={}, M={}, K={}, log2_divisor={}, "
                "trigger_mode={}, trigger_level={}"
                .format(self.N_ca, self.frec_objetivo, self.M, self.K,
                        self.log2_divisor, self.trigger_mode, self.trigger_level))
    
    # Cosas auxiliares para setear el divisor
    def check_limits(self):
        if ((math.log2(self.N_ca) + math.log2(self.K) - self.log2_divisor + 14 ) > 32):
            return 0
        else:
            return 1

    def set_divisor(self):
        self.log2_divisor = 0
        while self.check_limits() == 0:
            self.log2_divisor += 1  # Si no se cumplen los límites, aumenta el divisor

    @staticmethod
    def FrecuenciaReal(freq):
        # En realidad con el DDS compiler no genero una frecuencia exactamente como la que dice el parametro
        phase_inc = int(2.147483648 * freq)
        return phase_inc*125000000/(math.pow(2,28))