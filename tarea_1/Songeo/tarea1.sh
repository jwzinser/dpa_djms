#!/bin/bash

# Sonia Mendizábal
# Tarea 1
# DPA

# 1. Mezcla los comandos httppie, jq y csvkit para descargar las películas de StarWars 
# Guarda los campos de title, episode_id, director, producer, release_date, opening_crawl 
# en una base de datos sqlite llamada star_wars.db

http http://swapi.co/api/films/ | jq -r '.results | ( (map([keys[2,4,5,7,8,11]])) | add | unique) as $key | $key, (.[] | [.[$key[]]]) | @csv' | csvsql --db sqlite:/$


# 2. Usando bash crea un programa que descargue todas los resources de SWAPI
# Guárdalos en jsons separados usando como nombres de archivo la llave del json
# Procesa estos archivos con las herramientas del primer inciso de la tarea. 
# Al final deberías de tener 7 tablas en star_wars.db

hrefs=$(http GET http://swapi.co/api/ | jq '.[]' | sed 's/\"//g' | grep -Po '(?<=(api\/)).*(?=\/)')

mkdir jsons
for i in $hrefs;
    do
        http GET http://swapi.co/api/$i/ | jq '.results' > jsons/$i.json
        cat jsons/$i.json | jq -r '.' | in2csv -f json | csvsql --db sqlite:///star_wars.db --tables $i --insert
    done


