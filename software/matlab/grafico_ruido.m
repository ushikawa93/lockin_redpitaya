%% Graficos de ruido vs tiempo de integracion en algorimo CALI

% El ruido lo estimo con la desviacion estÃ¡ndar de las mediciones de
% amplitud
% El timpo de integracion lo obtengo a partir de N que es cantidad de
% ciclos promediados coherentemente


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
legend ( "Teórico", "Señal medida con ADC" );
xlabel ( " Tiempo de integración [s]" );
ylabel ( " Desviación estándar de amplitudes normalizadas " );


% Zoom inset
axes('Position', [0.55 0.6 0.3 0.2]);
semilogx(taos, std_teorica, '-k', 'LineWidth', 1.5,'MarkerSize',10); hold on;
semilogx(taos, std_adc_fpga, ':kx', 'LineWidth', 1.5,'MarkerSize',10);

xlim([0.00035 0.00040]);
ylim([0.03 0.08]);
title('Zoom (Tiempos de integración medios)');
grid on;




% Zoom inset
axes('Position', [0.55 0.3 0.3 0.2]);
semilogx(taos, std_teorica, '-k', 'LineWidth', 1.5,'MarkerSize',10); hold on;
semilogx(taos, std_adc_fpga, ':kx', 'LineWidth', 1.5,'MarkerSize',10);

xlim([taos(end)-0.0001 taos(end)]);
ylim([0.01 0.06]);
title('Zoom (Tiempos de integración largos)');
grid on;

% Ocultar valores del eje y en el nuevo grÃ¡fico (si lo deseas)
%set(gca, 'YTick', [0.03 0.08]);
%set(gca, 'XTick', [0.0004 0.0005]);


% Imprimir la figura en escala de grises
publicationPrint6(gcf, 40, [], 'Graficos de ruido rp-li', 'png',18);


