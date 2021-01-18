# CRON DATA PUMP export

#### Создаем файл instance_name.env который будет содержать переменное окружение:
```

vi /home/oracle/valentin.env

со следующим содержимым (подставляем свои значения для ORACLE_HOME, PATH, ORACLE_SID):

export ORACLE_HOME=/u01/app/oracle/product/12.2.0/dbhome_1

export PATH=$ORACLE_HOME/bin:$PATH

export ORACLE_SID=valentin

Сохраняем и выходим
```

#### Пишем скрипт который применяет перменное окружение и выполняет экспорт : называем его например script_export.sh :
```

vi /home/oracle/script_export.sh

со следующим содержимым:

#!/bin/bash

mydate=`date "+%H.%M_%d.%m.%Y"`     #### задаем переменную в которую записываем текущее время для подстановки в имя файла

source /home/oracle/valentin.env    #### применяем переменное окружение

impdp SYSTEM/password full=Y directory=dmpdir dumpfile=schema.dmp logfile=impdp_$mydate.log

Сохраняем и выходим
```

#### В терминале запускаем crontab (откроется текстовый файл в который и будем записывать что и когда выполнять):
```

$ crontab -e

59 18 * * * /home/oracle/script_export.sh &>> /u01/arch/cron_log/expdp_$mydate.log

# $>> перенаправляет стандартый поток вывода и поток вывода ошибок в один файл
скрипт будет выполняться каждый день в 18 ч 59 м.
```
