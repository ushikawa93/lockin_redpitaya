% ========================================================================
% Función: abrir_archivo_ignorando_header
% ========================================================================
% Descripción:
%   Lee un archivo de texto ignorando un número determinado de líneas
%   de cabecera al inicio. Luego, interpreta el contenido como columnas
%   numéricas y devuelve los datos en forma de matriz.
%
% Parámetros de entrada:
%   - nombre_archivo : cadena con la ruta o nombre del archivo a abrir.
%
% Parámetros de salida:
%   - data : matriz numérica con los datos leídos (cada columna corresponde
%            a una de las series en el archivo).
%
% Notas:
%   - El número de líneas de cabecera se define en la variable headerLines.
%   - El formato de lectura se define en textscan y puede ajustarse si
%     cambia la estructura del archivo.
%
% Autor: Matías Oliva
% Fecha: 2025
% ========================================================================



function [data] = abrir_archivo_ignorando_header(nombre_archivo)

    fileID = fopen(nombre_archivo);
    headerLines = 3; % Ajusta el n�mero de l�neas de cabecera
    for i = 1:headerLines
        fgetl(fileID); % Saltar l�neas de cabecera
    end
    data_cell = textscan(fileID, '%f, %f, %f'); % Ajusta el formato seg�n los datos
    fclose(fileID);
    
    % Convertir cell array a matriz
    data = cell2mat(data_cell);

end