
#!/bin/bash

# Mariana Carmona 114157
# Tarea 1 individual

# Inciso 1

http http://swapi.co/api/films/ | jq -r '.results | ((map([keys[2,4,5,7,8,11]])) | add | unique) as $col | $col, (.[] | [.[$col[]]]) | @csv' | csvsql --db sqlite:///star_wars.db --tables movies  --insert

# Inciso 2

hrefs=$(http GET http://swapi.co/api/ | jq '.[]' | sed 's/\"//g' | grep -Po '(?<=(api\/)).*(?=\/)')

mkdir json_files

for i in $hrefs;
    do
	echo $i
    done

for i in $hrefs;
    do
	http GET http://swapi.co/api/$i/ | jq '.results' > json_files/$i.json
	cat json_files/$i.json | jq -r '.' | in2csv -f json | csvsql --db sqlite:///star_wars.db --tables $i --insert
    done
