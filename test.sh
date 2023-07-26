#!/bin/bash

set -e

mkdir -p src

echo "hello markdown" > "src/markdown test.md"
echo "<p>hello html</p>" > "src/html test.html"
echo "hello plaintext" > "src/plaintext test.txt"

./build.sh "https://example.com"

read -r -d '' template << EOL || true
<!DOCTYPE html>
<html>
  <head>
    <title>%s</title>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  </head>
  <body>
    <main>%s</main>
  </body>
</html>
EOL

read -r -d '' sitemap << EOL || true
https://example.com/html%20test
https://example.com/markdown%20test
https://example.com/plaintext%20test.txt
EOL

if [[ "$sitemap" != "`cat dist/sitemap.txt`" ]] ; then
  echo "sitemap failed"
  echo -e "expected:" "$sitemap"
  echo -e "received:" "`cat dist/sitemap.txt`"
  echo
  exit 1
fi

md1=`printf "$template" "markdown test" "<p>hello markdown</p>"`
md2=`cat "dist/markdown test.html"`
if [[ "$md1" != "$md2" ]] ; then
  echo "markdown failed"
  echo -e "expected:" "$md1"
  echo -e "received:" "$md2"
  echo
  exit 1
fi

html1=`printf "$template" "html test" "<p>hello html</p>"`
html2=`cat "dist/html test.html"`
if [[ "$html1" != "$html2" ]] ; then
  echo "html failed"
  echo -e "expected:" "$html1"
  echo -e "received:" "$html2"
  echo
  exit 1
fi

txt1="hello plaintext"
txt2=`cat "dist/plaintext test.txt"`
if [[ "$txt1" != "$txt2" ]] ; then
  echo "plaintext failed"
  echo -e "expected:" "$txt1"
  echo -e "received:" "$txt2"
  echo
  exit 1
fi

rm -rf template.html src dist
