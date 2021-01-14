# Cоздать скрипт для архивирования логов. Две функции, которые вызываются
# в зависимости от переданного первого аргумента скрипту (использовать if )
# 1) Первая функция. Cоздаёт указанное число логов (т.е. файлов с расширением .log)
# с рандомным содержимым (строка в 32 символа) в указанной директории и меняет дату создания
# на 2 часа назад половине из них. (использовать for , touch , /dev/urandom + tr + fold + head ).
# Результат выполнения - 20 файлов с расширением .log и с рандомной строкой в 32 символа в каждом,
# 10 из них с change time 2 часа назад.
# 2) Вторая функция.  Находит логи (файлы с расширением .log) в той же указанной директории
# старше часа и сжимает их. Использовать find , gzip .
# Результат выполнения: 10 из 20 выше созданных файлов сжимаются (т.е. файл превращается в архив с расширением .gz)

```
# !/bin/bash

clear

BASEDIR=$(dirname $0)

function create_files()
{
  NUMBER_OF_FILES=$1

  if [ $NUMBER_OF_FILES -eq 0 ]; then
    echo "Number of files cannot be zero!"
    exit 1
  fi

  for num in `seq 1 $NUMBER_OF_FILES`; do
    touch ${BASEDIR}/file_${num}.log
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1 > ${BASEDIR}/file_${num}.log
      if [ $((num%2)) -eq 0 ]; then
        touch -d "2 hours ago" ${BASEDIR}/file_${num}.log
      fi
  done

echo "Created ${NUMBER_OF_FILES}!"
ls -l ${BASEDIR}/file_*.log
}


function gzip()
{
find $BASEDIR -name "*.log" -mmin +60 -exec gzip "{}" \;
}

########
#MAIN 1#
########

SCRIPT_ARG_1=$1
SCRIPT_ARG_2=$2

for i in `seq 1 2`; do
 var=SCRIPT_ARG_$i
 echo "SCRIPT_ARG_${i} has value ${!var}"
done


if [ "x$SCRIPT_ARG_1" == "xcreate" ]; then
 create_files $SCRIPT_ARG_2
elif [ "x$SCRIPT_ARG_1" == "xgzip" ]; then
 gzip
fi




########
#MAIN_2#  Альтернативный вариант
########


while true; do

read -p "Enter Function create or gzip: " FUNCTION

case $FUNCTION in
  create)
    read -p "Enter files number: " n
      create_files $n
      break
      ;;
   gzip)
    gzip
    break
      ;;
  *)
    echo "incorrect Function";;
esac
do
```
