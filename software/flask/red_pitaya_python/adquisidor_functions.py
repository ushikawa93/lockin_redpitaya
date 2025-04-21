from fpga_bridge import FPGA;
from condiciones_adquisicion import TriggerMode, CondicionesAdquisicion
import time
import numpy as np
import math

""" ------------------------------------------------------- """
""" ---------- DIRECCIONES DE MEMORIA DE INTERES ---------- """
""" ------------------------------------------------------- """   

START_ADDRESS = 0x40000000
DATA_CH_A_ADDRESS = 0x40000000
DATA_CH_B_ADDRESS = 0x40040000
CTRL_ADDRESS = 0x41200000 #Bit 0-> trigger / bit 1-> reset	
N_CA_ADDRESS = 0x41200008
DAC_ADDRESS = 0x41220000
M_ADDRESS = 0x41220008
K_OVERSAMPLING_ADDRESS = 0x41230000
LOG2_DIVISOR_ADDRESS = 0x41230008
FINISHED_ADDRESS = 0x41210000
TRIGGER_MODE_ADDRESS = 0x41240000
TRIGGER_LEVEL_ADDRESS = 0x41240008
LEVEL_TO_DETECT = 0x41250000


""" ------------------------------------------------------- """
""" ------------------ Clase Adquisidor ------------------- """
""" ------------------------------------------------------- """   
# Metodos estáticos para controlar la acción del adquisidor con promediacion coherente
# Para que esto funcione debe estar cargado el bitstream adquisidor_estable.sh
# Usa funciones definidas en fpga_bridge

class adquisidor:

    @staticmethod
    def set_fpga(name = "adquisidor_experimental.bit"):
        FPGA.set_fpga_bitstream(name)

    @staticmethod
    def ResetFPGA(fpga):
        # Reseteo la cosa
        fpga.write_in_address(CTRL_ADDRESS, 2)
        fpga.write_in_address(CTRL_ADDRESS, 0)
    
    @staticmethod
    def SetEnable(fpga):
        # Seteo el enable (o trigger)
        value = fpga.read_from_address(CTRL_ADDRESS)
        fpga.write_in_address(CTRL_ADDRESS, value | 1)

    @staticmethod
    def SetDacFrequency(fpga,freq_dac):
        # Seteo la frecuencia del DAC (parametro para el DDS compiler del lado de la FPGA)
        phase_inc = int(2.147483648 * freq_dac)
        fpga.write_in_address(DAC_ADDRESS, phase_inc)

    @staticmethod
    def SetM(fpga,M):
        # Seteo la cantidad de muestras por ciclo de señal
        fpga.write_in_address(M_ADDRESS, M)

    @staticmethod
    def SetSobremuestreo(fpga,K_sobremuestreo):
        # Seteo la cantidad de muestras que quiero promediar linealmente
        fpga.write_in_address(K_OVERSAMPLING_ADDRESS, K_sobremuestreo)

    @staticmethod
    def SetN_ca(fpga,N_ca):
        # Seteo la cantidad de muestras que quiero promediar coherentemente
        fpga.write_in_address(N_CA_ADDRESS, N_ca)

    @staticmethod
    def SetTriggerMode(fpga,trigger_mode):
        if isinstance(trigger_mode, TriggerMode):
            fpga.write_in_address(TRIGGER_MODE_ADDRESS, trigger_mode.value)
        else:
            raise ValueError("El argumento debe ser una instancia de TriggerMode.")
        
    @staticmethod
    def SetTriggerLevel(fpga,trigger_level):
        # 0 para disparo continuo / 1 para disparo por nivel
        fpga.write_in_address(TRIGGER_LEVEL_ADDRESS, trigger_level)

    @staticmethod
    def SetLevelToDetect(fpga,level):
        fpga.write_in_address(LEVEL_TO_DETECT, level)

    @staticmethod
    def SetDivisor(fpga,log2_divisor):
        fpga.write_in_address(LOG2_DIVISOR_ADDRESS, log2_divisor)

    
    @staticmethod
    def WaitForFin(fpga,f=1000000, Nca=1):
        timeout = 40 * (1 / f) * Nca
        start_time = time.time()
        while fpga.read_from_address(FINISHED_ADDRESS) == 0:
            if time.time() - start_time > timeout:
                raise TimeoutError("Tiempo de espera excedido en WaitForFin.")
            time.sleep(0.001)

    @staticmethod
    def read_bram_data(fpga,M, N_ca, K):
        def interpret_ca2(value):
            return value - 0x100000000 if value & 0x80000000 else value

        # Prealocar arrays en NumPy para mejorar rendimiento
        reads_chA = np.zeros(M - 1)
        reads_chB = np.zeros(M - 1)

        factor = 1 / (N_ca * K)

        # Leer todos los valores en un solo bucle
        for i in range(1, M):
            value_A = fpga.read_from_address(DATA_CH_A_ADDRESS + 4 * i)
            value_B = fpga.read_from_address(DATA_CH_B_ADDRESS + 4 * i)

            reads_chA[i - 1] = adquisidor.convertir2volt_adc(interpret_ca2(value_A)) * factor
            reads_chB[i - 1] = adquisidor.convertir2volt_adc(interpret_ca2(value_B)) * factor

        return reads_chA.tolist(), reads_chB.tolist()

    @staticmethod
    def convertir2volt_adc(tension):
        gain_error = 1.131
        offset_error = -0.015 
        medido = (tension)/8192
        return gain_error*(medido-offset_error)
    
    @staticmethod
    def adquirir(condiciones_adquisicion = None):
        condiciones = condiciones_adquisicion if condiciones_adquisicion is not None else CondicionesAdquisicion()

        print(condiciones)
        fpga=FPGA()

        adquisidor.SetDacFrequency(fpga,condiciones.get_frec_objetivo())
        adquisidor.SetSobremuestreo(fpga,condiciones.get_K())
        adquisidor.SetN_ca(fpga,condiciones.get_N_ca())
        adquisidor.SetTriggerMode(fpga,condiciones.get_Trigger_mode())
        adquisidor.SetTriggerLevel(fpga,condiciones.get_Trigger_level())
        adquisidor.SetDivisor(fpga,condiciones.get_Log2_divisor())
        adquisidor.SetM(fpga,condiciones.get_M())

        adquisidor.ResetFPGA(fpga)
        adquisidor.SetEnable(fpga)
        adquisidor.WaitForFin(fpga,condiciones.get_frec_objetivo(),condiciones.get_N_ca())

        cha_a,ch_b = adquisidor.read_bram_data(fpga,condiciones.get_M(),condiciones.get_N_ca(),condiciones.get_K())
        return cha_a,ch_b
    

if __name__ == "__main__":  
    adquisidor.set_fpga()
    cha_a,ch_b = adquisidor.adquirir(CondicionesAdquisicion( N_ca = 1, frec_objetivo = 100 ))
    print(cha_a)




