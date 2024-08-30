%% Graficos de ruido vs tiempo de integracion en algorimo CALI

% El ruido lo estimo con la desviacion estándar de las mediciones de
% amplitud
% El timpo de integracion lo obtengo a partir de N que es cantidad de
% ciclos promediados coherentemente

%% Medidas obtenidas en la FPGA:

archivo_adc = "../datos_adquiridos/barrido.dat";

data_adc = abrir_archivo_ignorando_header(archivo_adc);

std_adc_fpga = data_adc(:,3)/max(data_adc(:,3));
N = data_adc(:,1);

%% Vector de tiempos de integración:
f = 1e6;
M = 64e6/f;
T = 1/f;
taos = N*T;

%% Data teórica:

std_teorica = 1./sqrt(M.*N./2);
std_teorica = std_teorica./ max(std_teorica); % Normalizo

%% Graficos:

semilogx(taos, std_teorica, '-k', 'LineWidth', 1.5,'MarkerSize',10); hold on;
semilogx(taos, std_adc_fpga, ':kx', 'LineWidth', 1.5,'MarkerSize',10);


grid on;
legend ( "Theoretical", "Measured with ADC" );
xlabel ( " Integration time [s]" );
ylabel ( " Standard deviation of normalized amplitudes " );


% Zoom inset
axes('Position', [0.55 0.4 0.3 0.25]);
semilogx(taos, std_teorica, '-k', 'LineWidth', 1.5,'MarkerSize',10); hold on;
semilogx(taos, std_adc_fpga, ':kx', 'LineWidth', 1.5,'MarkerSize',10);

xlim([0.0004 0.0005]);
ylim([0.03 0.08]);
title('Zoom (longer integration times)');
grid on;

% Ocultar valores del eje y en el nuevo gráfico (si lo deseas)
set(gca, 'YTick', [0.03 0.08]);
set(gca, 'XTick', [0.0004 0.0005]);


% Imprimir la figura en escala de grises
%publicationPrint6(gcf, 26, [], 'Graficos de ruido N=512', 'png',18);


