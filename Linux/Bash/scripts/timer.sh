# Содержание скрипта: организация таймера  периодическая выдача на stdout сообщения
# о том, сколько времени прошло после запуска таймера (т.е. скрипта) и сколько осталось до конца
# работы. Параметры таймера передать при запуске скрипта через параметры

```
#!/bin/bash

read -p "enter time:" time
x=1
while true; do
sleep 1
echo "script executing for $x sec. script time until end $(( $time - $x ))"
    x=$(( $x + 1 ))
if [ $x -gt $time ]; then
break
fi
done
```
