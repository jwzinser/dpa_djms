# Juan Zinzer


# TAREA 1
rm -f star_wars.db
# inciso a
http http://swapi.co/api/films/ |jq  -r '.results |[(map(keys) | add | unique)[11,4,2,7,8,5]] as $cols | map(. as $row | $cols | map($row[.])) as $rows | $cols, $rows[] | @csv' | csvsql --db sqlite:///star_wars.db --tables films1  --insert


# inciso b
containsElement () {
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

api_names=$(http http://swapi.co/api/ | jq -r '.[]' |sed  's,http://swapi.co/api/,,' | sed 's,/,,')
array=(${api_names// / })
#array+=(url)

categories=$(http http://swapi.co/api/ | jq '.[]')
for i in $categories; do
    clean_http=$(echo $i | jq -r ".")
    key_name=$(echo $clean_http | sed  's,http://swapi.co/api/,,' | sed 's,/,,')
    echo $key_name
    http $clean_http | jq '.results' > "$key_name.json"

    # unicamente las columnas validas, es decir, las que no son url
    all_cols=$(cat "$key_name.json" | jq '. |(map(keys) | add | unique)| .[]')
    cand_col=$()
    for col in $all_cols; do
        FOUND=$(echo "${array[*]}" | grep -o $(echo $col| jq -r '.') )
        if [[ ${#FOUND} == 0 ]]; then
            col=$(echo $col | jq  '.')
            echo "$col"
            cand_col=$(echo $($cand_col) | jq --arg cand_col "$cand_col" '[$cand_col]')
            cand_col=$(|= .+ [...])
        fi
    done
    echo $cand_col
    cat "$key_name.json" | jq -r --arg cand_col "$cand_col" '. | [$cand_col] as $cols | map(. as $row | $cols | map($row[.])) as $rows | $cols, $rows[] | @csv' | csvsql --db sqlite:///star_wars.db --tables $key_name --insert
    #cat $key_name.json | jq -r '.' | in2csv -f json | csvsql --db sqlite:///star_wars.db --tables $key_name --insert
done








# creo mi llave 
# le doy *.pub al admin 
# modifico mi config para usar mi usuario y llave (esto esta ligado a un mail, no al usuario de la compu)
# 
#

# cat id_rsa.pub












