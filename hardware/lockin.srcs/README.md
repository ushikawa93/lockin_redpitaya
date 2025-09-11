# Archivos Fuente del proyecto de Hardware

En esta carpeta hay IPs (algunos propios y otros prestados) que implementan los distintos bloques de Hardware del diseño. Cada IP tiene un encabezado que describe brevemente su operación. Para integrar todos estos IPs en el diseño del lockin se utilizó un block diagram, definido en sources_1/bd/system.

## Estructura de la carpeta:

- constrs_1: Constraints del diseño (clocks y puertos)

- utils_1: Carpeta auxiliar con datos que necesita Vivado para generar el Block Design.

- lu_tables: Tablas de consulta para almacenar señales como senos y cosenos

- user_ip:
  - my_cores: IP propia escrita en Verilog para cumplir distintas funcionalidades
  - cores: IP externa utilizada por el programa. Acá están por ejemplo los drivers de DAC y ADC.

- sources_1
  - bd/ system: Carpeta generada por Vivado con todo el IP necesario para el block design. Acá lo importante es `system.bd`, después la carpeta ip se genera sola por Vivado a partir de este archivo y del código fuente.

  - imports: 
    - lu_tables: Tablas de consulta para almacenar señales como senos y cosenos
    - my_cores: IP propia escrita en Verilog para cumplir distintas funcionalidades
    - user_ip:
      - cores: IP externa utilizada por el programa. Acá están por ejemplo los drivers de DAC y ADC.
      - my_cores: IP propia escrita en Verilog para cumplir distintas funcionalidades
    - `system_wrapper.v`: Top level file del proyecto (generado por Vivado a partir del BD)
  
  - new: IP propia escrita en Verilog para cumplir distintas funcionalidades