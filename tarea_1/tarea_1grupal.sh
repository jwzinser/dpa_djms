# EQUIPO:
# Mariana Carmona
# Luis Daniel Hernandez
# Sonia Mendizabal
# Juan Zinzer


# TAREA 1
# Descarga de archivos
http http://data.gdeltproject.org/events/index.html | grep -Po '201(612|7..)[0-9][0-9]\.export.CSV.zip' | uniq | awk '{print "http://data.gdeltproject.org/events/"$1}' | parallel wget

# Peso
peso=$(du -h .)
echo "La descarga pesa:" $peso

# Numero de archivos
numarch=$(ls *.zip | wc -l)
echo "Número de archivos:" $numarch

