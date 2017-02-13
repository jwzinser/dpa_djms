# Juan Zinzer


# TAREA 1

# inciso a
# http http://swapi.co/api/films/ |jq  -r '.results |[(map(keys) | add | unique)[11,4,2,7,8,5]] as $cols | map(. as $row | $cols | map($row[.])) as $rows | $cols, $rows[] | @csv' | csvsql --db sqlite:///star_wars.db --insert | sql2csv --db sqlite:///star_wars.db --query "ALTER TABLE stdin RENAME TO star_wars"

# inciso b

categories=$(http http://swapi.co/api/ | jq '.[]')
for i in $categories; do
    clean_http=$(echo $i | jq -r ".")
    key_name=$(echo $clean_http | sed  's,http://swapi.co/api/,,' | sed 's,/,,')
    echo $key_name
    http $clean_http | jq '.' > "$key_name.json"
    # unicamente las columnas validas, es decir, las que no son url
    all_cols=$(cat "$key_name.json" | jq  '.results |(map(keys) | add | unique)')
    cand_col=$()
    for col in $all_cols; do
        col_val=$(cat "$key_name.json" | jq  '[.results[]| ."$col"] ')
        arr=$(declare -p $col_val  | jq '.[0]' | grep -q '^declare \-a' && echo array || echo no array)
        if [$arr=='no array']
            then
                cand_col+=("$col")
        fi
    done
    echo $cand_col
    cat "$key_name.json" | jq -r '.results |$all_cols as $cols | map(. as $row | $cols | map($row[.])) as $rows | $cols, $rows[] | @csv' | csvsql --db sqlite:///star_wars.db --table $key_name  --insert
    break
done






















