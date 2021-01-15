# Autorun Oracle Database on Linux (автозапуск Database после перезагрузки сервера)

#### при помощи любого текстового редактора в терминале открываем файл:
```
$ vi /etc/oratab

который содержит примерно следующее:

$ORACLE_SID:$ORACLE_HOME:<N|Y>  и выставлеям значение Y

EXAMPLE

valentin:/u01/app/oracle/product/12.2.0/dbhome_1:Y

сохраняем и закрываем
```

#### переходим в директорию /etc/init.d и при помощи текстового редактора создаем файл :
```
$ vi /etc/init.d/dbora          #### dbora имя файла

со следующим содержимым:

#!/bin/sh
ORACLE_HOME=/u01/app/oracle/product/11.2.0/dbhome_1    # подставляем свой ORACLE_HOME
ORACLE_OWNER=oracle                                    # подставляем свой ORACLE_OWNER

case "$1" in
'start') # Start the Oracle databases and listeners
su - $ORACLE_OWNER -c "$ORACLE_HOME/bin/dbstart $ORACLE_HOME"
;;
'stop') # Stop the Oracle databases and listeners
su - $ORACLE_OWNER -c "$ORACLE_HOME/bin/dbshut $ORACLE_HOME"
;;
esac

сохраняем и выходим
```

#### Меняем группу и задаем права для файла dbora:
```

$ chgrp dba dbora

$ chmod 750 dbora
```

#### Создаем ссылки:
```

$ ln -s /etc/init.d/dbora /etc/rc.d/rc0.d/K01dbora
$ ln -s /etc/init.d/dbora /etc/rc.d/rc3.d/S99dbora
$ ln -s /etc/init.d/dbora /etc/rc.d/rc5.d/S99dbora
```
