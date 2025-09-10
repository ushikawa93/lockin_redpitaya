% =========================================================================
% Script: ruido_vs_tiempo_integracion_CALI.m
% =========================================================================
% Descripción:
%   Este script grafica la relación entre el ruido y el tiempo de integración
%   en el algoritmo CALI, utilizando datos medidos en la FPGA y comparándolos
%   con la predicción teórica.
%
% Funcionalidades principales:
%   - Lectura de datos adquiridos en la FPGA desde archivos .dat.
%   - Cálculo del ruido como desviación estándar normalizada de la amplitud.
%   - Obtención del tiempo de integración a partir de N (cantidad de ciclos
%     promediados coherentemente).
%   - Cálculo del modelo teórico del ruido (1/sqrt(M·N/2)).
%   - (Opcional) Cálculo de la cota del error de cuantización.
%   - Graficado de ruido medido vs. ruido teórico en función del tiempo de
%     integración.
%   - Inclusión de recuadros de zoom para intervalos de tiempos cortos y
%     largos.
%   - Exportación de la figura en formato gráfico con escala de grises.
%
% Notas:
%   - El script depende de la función auxiliar abrir_archivo_ignorando_header.m.
%   - Algunas secciones (ej. cota de error de cuantización) están comentadas.
%   - Los parámetros de frecuencia f y decimación M deben ajustarse según el
%     experimento.
%
% Autor: Matías Oliva
% Fecha: 2025
% =========================================================================


%% Medidas obtenidas en la FPGA:

archivo_adc = "../datos_adquiridos/buenos/barrido_ruido_1N_4096N_f1MHz_100it.dat";
%archivo_adc = "../datos_adquiridos/barrido.dat";

data_adc = abrir_archivo_ignorando_header(archivo_adc);

std_adc_fpga = data_adc(:,3)/max(data_adc(:,3));
N = data_adc(:,1);

%% Vector de tiempos de integracion:
f = 1e6;
M = 125e6/f;
T = 1/f;
taos = N*T;

%% Data teorica:

std_teorica = 1./sqrt(M.*N./2);
std_teorica = std_teorica./ max(std_teorica); % Normalizo

%% Cota del error de cuantizacion (valido para f_m = k f_s)

%V_ff = 4096;

%cota_error = V_ff*sqrt(2)*2^(-n_bits)/max(std_teorica);

%% Graficos:
figure;
semilogx(taos, std_teorica, '-k', 'LineWidth', 1.5,'MarkerSize',10); hold on;
semilogx(taos, std_adc_fpga, ':kx', 'LineWidth', 1.5,'MarkerSize',10);
%plot(taos, cota_error*ones(size(taos)), 'k--', 'DisplayName', 'Cota Pesimista','LineWidth',5);


grid on;
legend ( "Te�rico", "Se�al medida con ADC" );
xlabel ( " Tiempo de integraci�n [s]" );
ylabel ( " Desviaci�n est�ndar de amplitudes normalizadas " );


% Zoom inset
axes('Position', [0.55 0.6 0.3 0.2]);
semilogx(taos, std_teorica, '-k', 'LineWidth', 1.5,'MarkerSize',10); hold on;
semilogx(taos, std_adc_fpga, ':kx', 'LineWidth', 1.5,'MarkerSize',10);

xlim([0.00035 0.00040]);
ylim([0.03 0.08]);
title('Zoom (Tiempos de integraci�n medios)');
grid on;




% Zoom inset
axes('Position', [0.55 0.3 0.3 0.2]);
semilogx(taos, std_teorica, '-k', 'LineWidth', 1.5,'MarkerSize',10); hold on;
semilogx(taos, std_adc_fpga, ':kx', 'LineWidth', 1.5,'MarkerSize',10);

xlim([taos(end)-0.0001 taos(end)]);
ylim([0.01 0.06]);
title('Zoom (Tiempos de integraci�n largos)');
grid on;

% Ocultar valores del eje y en el nuevo gráfico (si lo deseas)
%set(gca, 'YTick', [0.03 0.08]);
%set(gca, 'XTick', [0.0004 0.0005]);


% Imprimir la figura en escala de grises
publicationPrint6(gcf, 40, [], 'Graficos de ruido rp-li', 'png',18);


