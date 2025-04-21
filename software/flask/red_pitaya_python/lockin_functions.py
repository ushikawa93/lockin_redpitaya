from fpga_bridge import FPGA;
from resultado_lockin import CondicionesMedicion,FuenteDatos,ModoDecimacion,ResultadoLockin;
import time 
import math

""" ------------------------------------------------------- """
""" ---------- DIRECCIONES DE MEMORIA DE INTERES ---------- """
""" ------------------------------------------------------- """   

ENABLE_ADDRESS = 0x41230000
RESET_ADDRESS = 0x41230008

FINISH_ADDRESS = 0x41210000
RESULT_FASE_LOW_ADDRESS = 0x41200000
RESULT_FASE_HIGH_ADDRESS = 0x41200008
RESULT_CUAD_LOW_ADDRESS = 0x41220000
RESULT_CUAD_HIGH_ADDRESS = 0x41220008

FIFO_1_ADDRESS = 0x43c00000

M_ADDRESS = 0x41240000
N_ADDRESS = 0x41240008
DECIMATOR_ADDRESS = 0x41250000
DECIMATOR_METHOD_ADDRESS = 0x41210008
SELECT_DATA_ADDRESS = 0x41250008
N_DATOS_PROMEDIADOS_ADDRESS = 0x41270000

PHASE_DAC_ADDRESS = 0x41260000
PHASE_REF_ADDRESS = 0x41260008

""" ------------------------------------------------------- """
""" ---------------------- Clase Lockin ------------------- """
""" ------------------------------------------------------- """   
# Metodos estáticos para controlar la acción de lockin
# Para que esto funcione debe estar cargado el bitstream lockin_estable.sh
# Usa funciones definidas en resultado_lockin y fpga_bridge

class lockin:

    @staticmethod
    def set_fpga(name = "lockin_estable.bit"):
        FPGA.set_fpga_bitstream(name)
    
    @staticmethod
    def set_N(fpga,N):
        fpga.write_in_address(N_ADDRESS,N)

    @staticmethod
    def set_frec_ref(fpga,frec_ref):
        
        phase = 2.147483648 * frec_ref
        M = 125000000/lockin.FrecuenciaReal(frec_ref)

        fpga.write_in_address(M_ADDRESS,int(M))
        fpga.write_in_address(PHASE_REF_ADDRESS,int(phase))

    @staticmethod
    def set_frec_dac(fpga,frec_dac):
        phase = 2.147483648* frec_dac

        fpga.write_in_address(PHASE_DAC_ADDRESS,int(phase))

    @staticmethod
    def set_decimator(fpga,mode, decimator_value):
        if not isinstance(mode, ModoDecimacion):
            raise TypeError("El parámetro 'mode' debe ser una instancia de 'ModoDecimacion'")
        
        fpga.write_in_address(DECIMATOR_METHOD_ADDRESS, mode.value)
        fpga.write_in_address(DECIMATOR_ADDRESS, decimator_value)

    @staticmethod
    def set_data_mode(fpga,mode):
        if not isinstance(mode, FuenteDatos):  # Cambia según el tipo correspondiente
            raise TypeError("El parámetro 'mode' debe ser una instancia de 'DataMode'")
        
        fpga.write_in_address(SELECT_DATA_ADDRESS, mode.value)

    @staticmethod
    def Reset(fpga):
        fpga.write_in_address(ENABLE_ADDRESS,0)    
        fpga.write_in_address(RESET_ADDRESS,0)
        fpga.write_in_address(RESET_ADDRESS,1)

    @staticmethod
    def Enable(fpga):
        fpga.write_in_address(ENABLE_ADDRESS,1)

    @staticmethod
    def WaitForFin(fpga):
        while (fpga.read_from_address(FINISH_ADDRESS) == 0):
            time.sleep(0.001)

    @staticmethod
    def interpretar_como_ca2(parte_alta, parte_baja):
        resultado = (parte_alta << 32) | parte_baja
        # Extensión de signo si el MSB de parte_alta está activo
        if parte_alta & 0x80000000:  # Verifica si el bit 31 está en 1
            resultado -= 1 << 64     # Aplica la extensión de signo para 64 bits
        return resultado
 
    @staticmethod
    def MedirLockin(condiciones_medicion = None):
        condiciones = condiciones_medicion if condiciones_medicion is not None else CondicionesMedicion()
        fpga = FPGA()
        lockin.set_N(fpga,condiciones.get_N())
        lockin.set_frec_ref(fpga,condiciones.get_Frec_ref())
        lockin.set_frec_dac(fpga,condiciones.get_Frec_dac())
        lockin.set_data_mode(fpga,condiciones.get_Fuente_datos())
        lockin.set_decimator(fpga,condiciones.get_Modo_decimacion(), condiciones.get_Decimador())

        lockin.Reset(fpga)
        lockin.Enable(fpga)
        lockin.WaitForFin(fpga)

        res_up = fpga.read_from_address(RESULT_FASE_HIGH_ADDRESS)
        res_low = fpga.read_from_address(RESULT_FASE_LOW_ADDRESS)
        resultado_fase = lockin.interpretar_como_ca2(res_up,res_low)

        res_up = fpga.read_from_address(RESULT_CUAD_HIGH_ADDRESS)
        res_low = fpga.read_from_address(RESULT_CUAD_LOW_ADDRESS)
        resultado_cuad = lockin.interpretar_como_ca2(res_up,res_low)

        div = fpga.read_from_address(N_DATOS_PROMEDIADOS_ADDRESS)
        x = resultado_fase / div
        y = resultado_cuad / div

        resultado = ResultadoLockin(x,y,condiciones)
        print(resultado)
        print('\nDatos Promediados:' + str(div) + '\n')

        return resultado

    @staticmethod
    def convertir2volt_adc(tension):
        gain_error = 1.131
        offset_error = -0.015 
        medido = (tension)/8192
        return gain_error*(medido-offset_error)
   
    
    @staticmethod
    def leer_adc(reset = True, K=1 ):
        # Lista para almacenar los resultados
        data = []
        fpga = FPGA()

        if(reset):
            lockin.Reset(fpga)
            lockin.Enable(fpga)
            lockin.WaitForFin(fpga)

        # Número de elementos que quieres leer
        num_items = 514

        # Leemos los datos de la memoria (suponiendo que read_from_address() lee un valor de una dirección)
        for i in range(num_items):
            # Leemos desde la dirección calculada
            read_value = int(fpga.read_from_address(FIFO_1_ADDRESS + 0x20))

            # Convertir el valor en complemento a 2 a un entero con signo
            # Si el valor es mayor a 2^31, significa que el bit de signo está activado
            if read_value >= 2**31:
                read_value -= 2**32
            
            # Añadimos el valor leído a la lista
            data.append(lockin.convertir2volt_adc(read_value)/K)
        return data
    
    @staticmethod
    def FrecuenciaReal(freq):
        # En realidad con el DDS compiler no genero una frecuencia exactamente como la que dice el parametro
        phase_inc = int(2.147483648 * freq)
        return phase_inc*125000000/(math.pow(2,28))

if __name__ == "__main__":
    lockin.MedirLockin(CondicionesMedicion( N=32, fuente_datos=FuenteDatos.SIM,frec_ref=1000 ))
    #lockin.leer_adc()

        

