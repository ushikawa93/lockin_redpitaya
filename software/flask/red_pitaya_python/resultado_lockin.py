
from enum import Enum
import math

""" ------------------------------------------------------- """
""" -------------- Enumeraciones auxiliares --------------- """
""" ------------------------------------------------------- """   

class FuenteDatos(Enum):
    SIM = 0
    ADC = 1

    def __str__(self):
        if (self == FuenteDatos.SIM):
            return "Simulacion"
        elif (self == FuenteDatos.ADC):
            return "Datos ADC"

class ModoDecimacion(Enum):
    DISCARD = 0
    PROM = 1

    def __str__(self):
        if (self == ModoDecimacion.DISCARD):
            return "Descarte"
        elif (self == ModoDecimacion.PROM):
            return "Promedio lineal"


""" ------------------------------------------------------- """
""" ------- Clase para Condicones de medicion ------------- """
""" ------------------------------------------------------- """  

class CondicionesMedicion:
    
    # Valores por defecto
    _FREC_REF_DEFAULT = 1000000
    _FREC_DAC_DEFAULT = 1000000
    _N_DEFAULT = 32
    _FUENTE_DATOS_DEFAULT = FuenteDatos.SIM
    _MODO_DECIMACION_DEFAULT = ModoDecimacion.DISCARD
    _DECIMADOR_DEFAULT = 1

    def __init__(self, 
                 frec_ref=None, 
                 frec_dac=None, 
                 N=None, 
                 fuente_datos=None, 
                 modo_decimacion=None, 
                 decimador=None):

        self.frec_ref = frec_ref if frec_ref is not None else self._FREC_REF_DEFAULT
        self.frec_dac = frec_dac if frec_dac is not None else self._FREC_DAC_DEFAULT
        self.N = N if N is not None else self._N_DEFAULT
        self.fuente_datos = fuente_datos if fuente_datos is not None else self._FUENTE_DATOS_DEFAULT
        self.modo_decimacion = modo_decimacion if modo_decimacion is not None else self._MODO_DECIMACION_DEFAULT
        self.decimador = decimador if decimador is not None else self._DECIMADOR_DEFAULT

    # Getters
    def get_Frec_ref(self):
        return self.frec_ref

    def get_Frec_dac(self):
        return self.frec_dac

    def get_N(self):
        return self.N

    def get_Fuente_datos(self):
        return self.fuente_datos

    def get_Modo_decimacion(self):
        return self.modo_decimacion

    def get_Decimador(self):
        return self.decimador

    def __str__(self):
        return ("frec_ref={}, frec_dac={}, "
            "N={}\n fuente_datos={}, "
            "modo_decimacion={}, decimador={}"
            .format(self.frec_ref, self.frec_dac, 
                    self.N, self.fuente_datos, 
                    self.modo_decimacion, self.decimador))
 

""" ------------------------------------------------------- """
""" ------- Clase para Resultados de medicion ------------- """
""" ------------------------------------------------------- """  

class ResultadoLockin:

    BITS_REFERENCIA= 16
    AMPLITUD_REF = 2**(BITS_REFERENCIA-2)
    
    """Clase que almacena los resultados de una medición y sus condiciones"""
    def __init__(self, x, y, condiciones):
        self.x = x
        self.y = y
        self.r = ResultadoLockin.convertir2volt_lockin( math.sqrt(x**2 + y**2)* 2 / self.AMPLITUD_REF )
        self.phi = math.atan2(y, x)  # atan2 maneja correctamente el signo de x e y
        self.condiciones = condiciones  # Asociación directa con las condiciones

    def get_R(self):
        return self.r

    def get_phi(self):
        return self.phi
    
    def __str__(self):
        return ("r={}\nphi={}\nx={}\ny={}\n\n "
                "Condiciones: {}"
                .format(self.r, self.phi, self.x, self.y, self.condiciones))
    

    @staticmethod
    def convertir2volt_lockin(tension):
        medido = (tension)/8192
        correccion = 508/478; #Medido empiricamente
               
        return (medido*correccion)
