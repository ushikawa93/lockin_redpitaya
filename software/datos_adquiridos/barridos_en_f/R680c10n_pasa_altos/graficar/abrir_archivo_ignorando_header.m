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