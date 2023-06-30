#!/bin/bash

set -e

SAVEIFS=$IFS
IFS=`echo -en "\n\b"`

host="$1"

[ ! -f template.html ] && cat > template.html << EOL
<!DOCTYPE html>
<html>
  <head>
    <title>%s<title>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  </head>
  <body>
    <main>%s</main>
  </body>
</html>
EOL

rm -rf dist
mkdir -p src dist

# https://askubuntu.com/a/295312
urlencode() {
  local length="${#1}"
  for (( i = 0; i < length; i++ )); do
    local c="${1:i:1}"
    case $c in
      [a-zA-Z0-9.~_-]) printf "$c" ;;
      *) printf '%%%02X' "'$c"
    esac
  done
}

[ "`ls -A src`" ] && for path in ./src/* ; do

  file=`basename $path`
  title="${file%%.*}"

  if [[ $file == *.html ]] ; then
    echo "$host/`urlencode $title`" >> "dist/sitemap.txt"
    printf "`cat template.html`" "$title" "`cat src/$file`" > "dist/$file"
  elif [[ $file == *.md ]] ; then
    echo "$host/`urlencode $title`" >> "dist/sitemap.txt"
    printf "`cat template.html`" "$title" "`pandoc -f markdown -t html src/$file`" > "dist/$title.html"
  else
    echo "$host/`urlencode $file`" >> "dist/sitemap.txt"
    cp "src/$file" "dist/$file"
  fi

done
