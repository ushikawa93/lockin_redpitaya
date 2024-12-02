function [data] = abrir_archivo_ignorando_header(nombre_archivo)

    fileID = fopen(nombre_archivo);
    headerLines = 3; % Ajusta el número de líneas de cabecera
    for i = 1:headerLines
        fgetl(fileID); % Saltar líneas de cabecera
    end
    data_cell = textscan(fileID, '%f, %f, %f'); % Ajusta el formato según los datos
    fclose(fileID);
    
    % Convertir cell array a matriz
    data = cell2mat(data_cell);

end