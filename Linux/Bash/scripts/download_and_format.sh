# На основе case.
# Первый параметр download . Скачать страницу в файл с сайта https://sjmulder.nl/en/textonly.html
# Второй параметр parse . Из файла удалить всё содержимое между тегами <style> , затем удалить все html теги из файла
# Использовать утилиты: curl, sed

```
#!/bin/bash

clear


function download()
{
curl -o index.html https://sjmulder.nl/en/textonly.html
}

function parse()
{
sed -e '/<style>/,/<\/style>/d' -e :a -e 's/<[^>]*>//g;/</N;//ba' index.html
}


######
#MAIN#
######

function=$1

if [[ $function == "download" ]] || [[ $function == "parse" ]]; then
  case $function in
    download)
      download;;
    parse)
      parse;;
    *)
      echo "no correct function!"
  esac
else
  echo "no correct function!"
fi
```
