# Содержание скрипта: выдача сразу трех временных штампов для заданного имени файла

```
#!/bin/bash

read -p "Enter file name: " file_names

echo -e "Entered files: ${file_names} \n"


for file_name in $file_names; do

 echo "stat for file: $file_name"
 echo "==================="
 stat --printf="Access: %x \nModify: %y \nChange: %z \n" ${file_name}
 echo -e "=================== \n"

done
```
