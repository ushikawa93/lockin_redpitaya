%% Graficos de barrido en frecuencia para RP-li
% Este script esta optimizado para los par�metros R=10k C=1n (tama�o de los
% zooms y dem�s)

%% Medidas obtenidas en la FPGA:

archivo_adc = "../barrido_en_f_R680_c1n_4.dat";

data_adc = abrir_archivo_ignorando_header(archivo_adc);

f = data_adc(:,1); % Frecuencias
r = data_adc(:,2)./max(data_adc(:,2)); % Magnitud medida
phi = data_adc(:,3); % Fase medida


%% Medidas obtenida6s con sr865

archivo_sr865 =  "../r680_c1n_sr865.dat";

% Abrir el archivo 1 para lectura
fileID = fopen(archivo_sr865, 'r');

% Leer la primera l�nea (informaci�n de encabezado)
fgetl(fileID);

% Leer los datos usando textscan
formatSpec = '%d%f%f%f%f';
data1 = textscan(fileID, formatSpec, 'Delimiter', ',', 'HeaderLines', 1);

% Extraer info
f1 = data1{1};
R_SR865 = data1{4};
R_SR865=R_SR865/R_SR865(1);
phi_SR865 = data1{5};



%% Datos teoricos -> Transferencia de filtro RC

R = 680; % Resistencia de 680
C = 1e-9; % Capacitancia de 1 nF

H = 1 ./ (1 + 1i*2*pi*R*C.*f); % Respuesta en frecuencia del filtro RC pasa bajos

% C�lculo de la magnitud y fase de la respuesta te�rica
magnitud_teorica = abs(H);
fase_teorica = angle(H) * (180/pi); % Convertir de radianes a grados

% Calcular la frecuencia de corte (fase = -45 grados)
fcorte = 1 / (2 * pi * R * C);

%% Gr�ficos

figure('Position', [100, 100, 800, 600]);
markersize = 4; linewidth = 0.5;

% Primer gr�fico: Magnitud
subplot(2, 1, 1); 
semilogx(f, r, '-ko', 'DisplayName', 'Datos medidos (Red Pitaya)','LineWidth', linewidth,'MarkerSize',markersize); hold on;
semilogx(f, R_SR865, '-kx', 'DisplayName', 'Datos medidos (SR865)','LineWidth', linewidth,'MarkerSize',markersize); 
semilogx(f, magnitud_teorica, '-k^', 'DisplayName', 'Te�rico RC','LineWidth', linewidth,'MarkerSize',markersize); 
xlim([0,f(end)]); 
ylim([0,1.1]);
plot([fcorte fcorte], ylim, '--k','DisplayName', 'Frecuencia de corte','LineWidth', linewidth,'MarkerSize',markersize); 
text(fcorte, min(ylim) + (max(ylim) - min(ylim)) * 0.1, sprintf('%.1f Hz', fcorte), 'Color', 'black', 'FontSize', 10); 

grid on;
xlabel('Frecuencia (Hz)');
ylabel('Magnitud (dB)');
title('Respuesta en frecuencia: Magnitud');

%Crear el gr�fico de zoom para Magnitud
axes('Position', [0.25, 0.70, 0.2, 0.15]); % Ajusta la posici�n y el tama�o del zoom
box on;
semilogx(f, r, '-ko', 'LineWidth', linewidth,'MarkerSize',markersize); hold on;
semilogx(f, R_SR865, '-kx', 'LineWidth', linewidth,'MarkerSize',markersize); 
semilogx(f, magnitud_teorica, '-k^', 'LineWidth', linewidth,'MarkerSize',markersize); 
xlim([fcorte * 0.94, fcorte * 1.05]); % Ajusta la ventana de zoom alrededor de fcorte
ylim([0.65 0.78]); % Ajusta los l�mites de Y seg�n sea necesario
title("Zoom en amplitud");
grid on;

% Segundo gr�fico: Fase
subplot(2, 1, 2); 
semilogx(f, phi, '-ko', 'DisplayName', 'Datos medidos (Red Pitaya)','LineWidth', linewidth,'MarkerSize',markersize); hold on;
semilogx(f, phi_SR865, '-kx', 'DisplayName', 'Datos medidos (SR865)','LineWidth', linewidth,'MarkerSize',markersize); 
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

%Crear el gr�fico de zoom para Fase
axes('Position', [0.25, 0.2, 0.2, 0.15]); % Ajusta la posici�n y el tama�o del zoom
box on;
semilogx(f, phi, '-ko', 'LineWidth', linewidth,'MarkerSize',markersize); hold on;
semilogx(f, phi_SR865, '-kx', 'LineWidth', linewidth,'MarkerSize',markersize); 
semilogx(f, fase_teorica, '-k^', 'LineWidth', linewidth,'MarkerSize',markersize); 
xlim([fcorte * 0.94, fcorte * 1.05]); % Ajusta la ventana de zoom alrededor de fcorte
ylim([-47 -41]); % Ajusta los l�mites de Y seg�n sea necesario
title("Zoom en fase");

grid on;


publicationPrint6(gcf,40,[],'Medicion de transferencia RP-li (R10k c1n)','png',18);


%% Diferencias entre SR865 y RP:

fprintf ( "Diferencia media de R entre SR865 y CALI: %f (%f %%) \n", mean(abs(R_SR865-r)),100*mean(abs(R_SR865-r)));
fprintf ( "Maxima diferencia de R entre SR865 y CALI: %f (%f %%) \n", max(abs(R_SR865-r)),100*max(abs(R_SR865-r)));

fprintf ( "Diferencia media de phi entre SR865 y CALI: %f (%f %%) \n", mean(abs(phi_SR865-phi)),100*mean(abs(phi_SR865-phi))/360);
fprintf ( "Maxima diferencia de phi entre SR865 y CALI: %f (%f %%)\n", max(abs(phi_SR865-phi)),100*max(abs(phi_SR865-phi))/360);
 

