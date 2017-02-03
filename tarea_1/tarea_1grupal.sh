
# Pregunta 1.
http http://data.gdeltproject.org/events/index.html | grep -Po '201(612|7..)[0-9][0-9]\.export.CSV.zip' | uniq | awk '{print "http://data.gdeltproject.org/events/"$1}' | parallel wget

