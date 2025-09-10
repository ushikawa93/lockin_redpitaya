% =========================================================================
% Script: barrido_en_frecuencia_RP_li.m
% =========================================================================
% Descripción:
%   Este script genera y analiza barridos en frecuencia obtenidos con la
%   Red Pitaya (RP-li), comparándolos con mediciones realizadas con un
%   lock-in SR865 y con la respuesta teórica de un filtro RC.
%
% Funcionalidades principales:
%   - Lectura de datos medidos en la FPGA desde archivos .dat.
%   - Normalización y graficado de magnitud y fase de la respuesta medida.
%   - (Opcional) Lectura de datos medidos con SR865 para comparación.
%   - Cálculo de la respuesta teórica de un filtro RC (magnitud y fase).
%   - Cálculo de la frecuencia de corte teórica y marcado en los gráficos.
%   - Generación de gráficos en escala logarítmica (magnitud y fase),
%     con opción de añadir ventanas de zoom.
%   - Comparación cuantitativa entre datos RP y SR865 (diferencia media
%     y máxima en magnitud y fase).
%
% Notas:
%   - Varias secciones están comentadas (lectura de SR865, zooms,
%     publicación de figuras).
%   - El script usa la función auxiliar abrir_archivo_ignorando_header.m
%     para leer archivos de datos ignorando encabezados.
%   - Parámetros R y C definen el filtro RC simulado.
%
% Autor: Matías Oliva
% Fecha: 2025
% =========================================================================


%% Graficos de barrido en frecuencia para RP-li

%% Medidas obtenidas en la FPGA:

%archivo_adc = "../datos_adquiridos/barridos_en_f/r680c1n/barrido_en_f_R680_c10n_passa_altos.dat";
archivo_adc = "../datos_adquiridos/barrido_en_f.dat";

data_adc = abrir_archivo_ignorando_header(archivo_adc);

f = data_adc(:,1); % Frecuencias
r = data_adc(:,2)./max(data_adc(:,2)); % Magnitud medida
phi = data_adc(:,3); % Fase medida


%% Medidas obtenida6s con sr865

%archivo_sr865 =  "../datos_adquiridos/barridos_en_f/r680c1n/r680_c1n_sr865_single_ended.dat";

% Abrir el archivo 1 para lectura
%fileID = fopen(archivo_sr865, 'r');

% Leer la primera l�nea (informaci�n de encabezado)
%fgetl(fileID);

% Leer los datos usando textscan
%formatSpec = '%d%f%f%f%f';
%data1 = textscan(fileID, formatSpec, 'Delimiter', ',', 'HeaderLines', 1);

% Extraer info
%f1 = data1{1};
%R_SR865 = data1{4};
%R_SR865=R_SR865/R_SR865(1);
%phi_SR865 = data1{5};


%% Datos teoricos -> Transferencia de filtro RC

R = 680; % Resistencia de 10 kOhm
C = 10e-9; % Capacitancia de 1 nF

%H = 1 ./ (1 + 1i*2*pi*R*C.*f); % Respuesta en frecuencia del filtro RC pasa bajos
H = 1i*R*C*2*pi*f ./( 1 + 1i*2*pi*R*C.*f  );

% C�lculo de la magnitud y fase de la respuesta te�rica
magnitud_teorica = abs(H);
fase_teorica = angle(H) * (180/pi); % Convertir de radianes a grados

% Calcular la frecuencia de corte (fase = -45 grados)
fcorte = 1 / (2 * pi * R * C);

%% Gr�ficos

figure('Position', [100, 100, 800, 600]);
markersize = 10; linewidth = 1;

% Primer gr�fico: Magnitud
subplot(2, 1, 1); 
semilogx(f, r, '-ko', 'DisplayName', 'Datos medidos (Red Pitaya)','LineWidth', linewidth,'MarkerSize',markersize); hold on;
%semilogx(f, R_SR865, '-kx', 'DisplayName', 'Datos medidos (SR865)','LineWidth', linewidth,'MarkerSize',markersize); 
semilogx(f, magnitud_teorica, '-k^', 'DisplayName', 'Te�rico RC','LineWidth', linewidth,'MarkerSize',markersize); 
plot([fcorte fcorte], ylim, '--k','DisplayName', 'Frecuencia de corte','LineWidth', linewidth,'MarkerSize',markersize); 
text(fcorte, min(ylim) + (max(ylim) - min(ylim)) * 0.1, sprintf('%.1f Hz', fcorte), 'Color', 'black', 'FontSize', 10); 
xlim([0,f(end)]); 
ylim([0,1.1]);

grid on;
xlabel('Frecuencia (Hz)');
ylabel('Magnitud (dB)');
title('Respuesta en frecuencia: Magnitud');
%legend show;

% Crear el gr�fico de zoom para Magnitud
% axes('Position', [0.25, 0.65, 0.2, 0.15]); % Ajusta la posici�n y el tama�o del zoom
% box on;
% semilogx(f, r, '-ko', 'LineWidth', linewidth,'MarkerSize',markersize); hold on;
% semilogx(f, R_SR865, '-kx', 'LineWidth', linewidth,'MarkerSize',markersize); 
% semilogx(f, magnitud_teorica, '-k^', 'LineWidth', linewidth,'MarkerSize',markersize); 
% xlim([fcorte * 0.97, fcorte * 1.02]); % Ajusta la ventana de zoom alrededor de fcorte
% ylim([0.70 0.72]); % Ajusta los l�mites de Y seg�n sea necesario
% title("Zoom en amplitud");
% grid on;

% Segundo gr�fico: Fase
subplot(2, 1, 2); 
semilogx(f, phi, '-ko', 'DisplayName', 'Datos medidos (Red Pitaya)','LineWidth', linewidth,'MarkerSize',markersize); hold on;
%semilogx(f, phi_SR865, '-kx', 'DisplayName', 'Datos medidos (SR865)','LineWidth', linewidth,'MarkerSize',markersize); 
semilogx(f, fase_teorica, '-k^', 'DisplayName', 'Te�rico RC','LineWidth', linewidth,'MarkerSize',markersize); 
plot([fcorte fcorte], ylim, '--k','DisplayName', 'Frecuencia de corte','LineWidth', linewidth,'MarkerSize',markersize); 
text(fcorte, min(ylim) + (max(ylim) - min(ylim)) * 0.1, sprintf('%.1f Hz', fcorte), 'Color', 'black', 'FontSize', 10); 
xlim([0,f(end)]); 

% A�adir la leyenda
lgd = legend('Datos medidos (Red Pitaya)','Datos medidos (SR865)','Te�rico RC','Frecuencia de corte');

% Ajustar la posici�n de la leyenda
set(lgd, 'Position', [0.75, 0.4, 0.2, 0.1]); % [x, y, ancho, alto]
set(lgd, 'Units', 'normalized'); % Usar unidades normalizadas

% Adjust font properties
set(findall(gcf,'-property','FontName'),'FontName','Times New Roman');
set(findall(gcf,'-property','FontSize'),'FontSize',14);

grid on;
xlabel('Frecuencia (Hz)');
ylabel('Fase (�)');
title('Respuesta en frecuencia: Fase');
%legend show;

% Crear el gr�fico de zoom para Fase
% hZoomFase = axes('Position', [0.25, 0.2, 0.2, 0.15]); % Ajusta la posici�n y el tama�o del zoom
% box on;
% semilogx(f, phi, '-ko', 'LineWidth', linewidth,'MarkerSize',markersize); hold on;
% semilogx(f, phi_SR865, '-kx', 'LineWidth', linewidth,'MarkerSize',markersize); 
% semilogx(f, fase_teorica, '-k^', 'LineWidth', linewidth,'MarkerSize',markersize); 
% xlim([fcorte * 0.97, fcorte * 1.02]); % Ajusta la ventana de zoom alrededor de fcorte
% ylim([-46 -43]); % Ajusta los l�mites de Y seg�n sea necesario
% title("Zoom en fase");
% 
% grid on;
% 
% 
% 

%publicationPrint6(gcf,30,[],'Medicion de transferencia RP-li (R10k c1n)','png',18);


%% Diferencias entre SR865 y RP:

fprintf ( "Diferencia media de R entre SR865 y CALI: %f (%f %%) \n", mean(abs(R_SR865-r)),100*mean(abs(R_SR865-r)));
fprintf ( "Maxima diferencia de R entre SR865 y CALI: %f (%f %%) \n", max(abs(R_SR865-r)),100*max(abs(R_SR865-r)));

fprintf ( "Diferencia media de phi entre SR865 y CALI: %f (%f %%) \n", mean(abs(phi_SR865-phi)),100*mean(abs(phi_SR865-phi))/360);
fprintf ( "Maxima diferencia de phi entre SR865 y CALI: %f (%f %%)\n", max(abs(phi_SR865-phi)),100*max(abs(phi_SR865-phi))/360);
 

