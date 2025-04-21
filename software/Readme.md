# Pasos para instalar Mati's Lockin en Red Pitaya:

1) Copiar la carpeta lockin_mati de resources a /opt/redpitaya/www/apps
	-> Esto hace que aparezca la opcion en el Desktop de Red Pitaya
	
2) Reemplazar el archivo de configuración de nginx por el nginx.conf de resources
	-> En mi version de Red Pitaya esto esta en /opt/redpitaya/www/apps
	-> Esto pone a correr el servidor flask en http://rp-f058e5.local/lockin/
	
3) Agregar el servicio lockin_web.service a los servicios de ubuntu
	-> Para esto basta con agregar ese archivo a /etc/systemd/systemd/sys
	
4) Copiar la carpeta flask a /root/