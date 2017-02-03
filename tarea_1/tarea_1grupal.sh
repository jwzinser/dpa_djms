# EQUIPO:
# Mariana Carmona
# Luis Daniel Hernandez
# Sonia Mendizabal
# Juan Zinzer

#!/bin/sh


# TAREA 1
# Descarga de archivos
http http://data.gdeltproject.org/events/index.html | grep -Po '201(612|7..)[0-9][0-9]\.export.CSV.zip' | uniq | awk '{print "http://data.gdeltproject.org/events/"$1}' | parallel wget

# Peso
peso=$(du -h .)
echo "La descarga pesa:" $peso

# Numero de archivos
numarch=$(ls *.zip | wc -l)
echo "Número de archivos:" $numarch

# A base sqlite
ls *.zip | parallel -j100 zgrep -e "Mexico" | csvsql --db sqlite:///gdelt.db --no-header-row --table mexico --insert
#parallel zgrep -e "Mexico" *.zip | csvsql --db sqlite:///industry_data.db --insert
#

sql2csv --db sqlite:///gdelt.db --query  "drop table mexico_ts;"
sql2csv --db sqlite:///gdelt.db --query  "create table mexico_ts('date', 'events', 'goldstein_score');"
sql2csv --db sqlite:///gdelt.db --query  "INSERT INTO mexico_ts ('date', 'events', 'goldstein_score') select column57 as date, count(*) as events, avg(column31) as goldstein_score from mexico group by date;"


sql2csv --db sqlite:///gdelt.db --query  "drop table mexico_ts;"
sql2csv --db sqlite:///gdelt.db --query "select column57 as date, count(*) as events, avg(column31) as goldstein_score  from mexico group by date;" | tee | csvsql --db sqlite:///gdelt.db  --table mexico_ts --insert
sql2csv --db sqlite:///gdelt.db --query "select column57 as date, count(*) as events, avg(column31) as goldstein_score  from mexico group by date;"  | csvsql --db sqlite:///gdelt.db  --table mexico_ts_2 --insert
