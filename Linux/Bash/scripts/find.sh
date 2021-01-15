# Содержание скрипта: получение рекурсивного списка файлов, имеющих длинные имена
# (больше заданного числа), сортировка по полному имени файлов (включающему полное путевое
# имя, начиная с /) и выдача полученного списка во вьюер и, одновременно, в файл. Параметры
# скрипта: имя директории, в которой производится рекурсивный поиск, и натуральное число  ми-
# нимальная длина имени.

```
#!/bin/bash
SEARCHPATH=$(dirname `readlink -f $0`)
MIN_LENGTH=$1
if [ -z $MIN_LENGTH ]; then
  echo error!
  exit 1
fi

if [ ! -z $2 ]; then
  SEARCHPATH=$2
fi

find $SEARCHPATH -type f -regextype posix-egrep -regex ".*/[^/]{$MIN_LENGTH}.*" | grep -v "$0" | sort | tee -a /tmp/script.log
```