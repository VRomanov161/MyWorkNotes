# Содержание скрипта: замена существующего расширения в имени файла на заданное.
# Исходное имя файла и новое расширение передаются скрипту в качестве параметров.

```
#!/bin/bash

clear

BASEDIR=$(dirname $0)

function create_files {
  NUMBER_OF_FILES=$1
  FILE_EXTENSION=$2
  if [ $NUMBER_OF_FILES -eq 0 ]; then
    echo "Number of files cannot be zero!"
    exit 1
  fi

  for num in `seq 1 $NUMBER_OF_FILES`; do
    touch ${BASEDIR}/file_${num}.${FILE_EXTENSION}
  done

  echo "Created ${NUMBER_OF_FILES} with extension ${FILE_EXTENSION}:"
  ls -l ${BASEDIR}/file_*.${FILE_EXTENSION}
}


function rename {
  SOURCE_EXT=$1
  TARGET_EXT=$2
  echo "Renaming *.${SOURCE_EXT} to *.${TARGET_EXT} ..."
  echo "Old files:"
    cd ${BASEDIR}
    ls -l *.${SOURCE_EXT}
  for file in *.${SOURCE_EXT}; do
    mv "$file" "${file%.$SOURCE_EXT}.${TARGET_EXT}"
  done
  echo "New files:"
    ls -l *.${TARGET_EXT}
}


########
# MAIN #
########

SCRIPT_ARG_1=$1
SCRIPT_ARG_2=$2
SCRIPT_ARG_3=$3

for i in `seq 1 3`; do
 var=SCRIPT_ARG_$i
 echo "SCRIPT_ARG_${i} has value ${!var}"
done

if [ "x$SCRIPT_ARG_1" == "xcreate" ]; then
 create_files $SCRIPT_ARG_2 $SCRIPT_ARG_3
elif [ "x$SCRIPT_ARG_1" == "xrename" ]; then
 rename $SCRIPT_ARG_2 $SCRIPT_ARG_3
else
 echo "Incorrect action !"
 exit 1
fi
```
