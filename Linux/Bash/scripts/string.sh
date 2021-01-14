# Содержание скрипта: выделение из исходной строки подстроки с границами, заданными
# порядковыми номерами символов в исходной строке.

```
#!/bin/bash
echo "enter string"
   read string
echo "enter number string"
   read number
echo "enter number string 2"
   read number2
echo $string | cut -c${number}-${number2}
```
