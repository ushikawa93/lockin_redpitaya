function publicationPrint6(fig,ancho,alto,nombre_archivo,tipo,fsz)
% function publicationPrint6(fig,ancho,alto,nombre_archivo,tipo,fsz)
% Asigna un tamaño en cm a la figura, cambia letra a Times New Roman 11 y
% exporta una imágen del tipo pedido.
% ARGUMENTOS:
% fig: handle a la figura
% ancho: ancho en cm
% alto: alto en cm o array vacío [] para relación 1.6
% nombre: nombre del archivo
% tipo: Tipo de archivo a generar: 'png' , 'eps', 'pdf'
% OPCIONAL: 
% fsz: tamaño de letra
% EJEMPLO: publicationPrint6(gcf,8.6,[],'Figura1','eps')
%   guarda la figura actual en el directorio actual, con ancho 8.6 
%   y alto 8.6/1.6

if(nargin <6)
    fsz = 11;      % Fontsize
end

Gr=1.61803398875;
if isempty(alto)
    alto=ancho/Gr;
end

set(fig.Children, ...
    'FontName',     'Times New Roman', ...
    'FontSize',     fsz);

alw = 0.5;
set(findall(fig,'type','axes'),'FontSize',fsz,'FontName','Times New Roman','LineWidth', alw);
set(findall(fig,'type','text'),'FontSize',fsz,'FontName','Times New Roman');
set(findall(fig,'type','axis'),'FontSize',fsz,'FontName','Times New Roman')

set(fig,'color','white');

% scaling
fig.Units               = 'centimeters';
fig.Position(3)         = ancho;
fig.Position(4)         = alto;

set(fig, ...
    'units', 'centimeters', ...
    'PaperUnits', 'centimeters', ...
    'PaperPositionMode', 'manual',...
    'PaperSize', [ancho alto], ...    
    'Position', [0 0 ancho alto], ...
    'color','white');

set(fig,'PaperPositionMode','auto');

set(gca,'LooseInset', max(get(gca,'TightInset'), 0.02))

set(fig,'PaperPositionMode','auto');

if(strcmp(tipo,'png') == true)
    file_nombre = strcat(nombre_archivo,'.png');
    print(gcf, file_nombre,'-dpng','-r600');
end

if(strcmp(tipo,'eps')==true)
    file_nombre = strcat(nombre_archivo,'.eps');
    print(gcf, file_nombre,'-deps','-r600');
end


if(strcmp(tipo,'pdf')==true)
    file_nombre = strcat(nombre_archivo,'.pdf');
    print(gcf, file_nombre,'-dpdf');
end
