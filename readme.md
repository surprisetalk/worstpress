# WorstPress

## Install

```bash
brew install pandoc
curl https://raw.githubusercontent.com/surprisetalk/worstpress/main/build.sh > build.sh
chmod a+x build.sh
```

## Make a Website

```bash
echo 'hello world' > src/index.md
./build.sh 'https://example.com'
```

## Edit Your Template

```bash
nano template.html
```

## Start a Development Server

```bash
brew install http-server
http-server dist
```

```bash
brew install watch
watch -p "*.html" -p "src/*" -c "./build.sh"
```
