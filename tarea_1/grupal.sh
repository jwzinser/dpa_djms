# EQUIPO:
# Mariana Carmona
# Luis Daniel Hernandez
# Sonia Mendizabal
# Juan Zinzer

#!/bin/sh


# TAREA 1
#Descarga de archivos
http http://data.gdeltproject.org/events/index.html | grep -Po '201(612|7..)[0-9][0-9]\.export.CSV.zip' | uniq | awk '{print "http://data.gdeltproject.org/events/"$1}' | parallel wget 


#Estadisticas, busqueda de informacion y creacion de la base de datos
(echo "Los archivos descargados pesan: `du -h .`"; echo "El numero de archivos descargados es: `ls *.zip | wc -l`") | ls *.zip | parallel -j0 zgrep -e "Mexico" | csvsql --db sqlite:///gdelt.db --no-header-row --table mexico --insert


#Busqueda de informacion 
sql2csv --db sqlite:///gdelt.db --query "select column57 as date, count(*) as events, avg(column31) as goldstein_score from mexico group by date;" | csvsql --db sqlite:///gdelt.db --table mexico_ts --insert
