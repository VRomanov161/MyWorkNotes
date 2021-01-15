# Oracle Data Pump

## Data Pump Export

#### Создаем директорию куда будет выполняться экспорт :
```
$ mkdir -p /u03/oradata/datapump

$ chown -R oracle:dba /u03/oradata/datapump
```

###### *задаем переменую времени по необходимости*
```

$ mydate=`date "+%H.%M_%d.%m.%Y"`
```

#### далее создаем ссылку в базе данных на каталог операционной системы, который создали ранее :
```

SQL> CREATE OR REPLACE DIRECTORY dmpdir AS '/u03/oradata/datapump';
```

###### *Посмотреть уже имеющиеся каталоги:*
```

SQL> set linesize 200
     set pagesize 0
     col directory_name format a30
     col directory_path format a60
     select directory_name, directory_path from dba_directories;
```

#### Далее в терминале выполняем команду expdp которой передаем что нужно экспортировать (в данном примере схему hr), указываем ранее созданную директорию куда будет производиться экспорт, а так же имя DUMPFILE и LOGFILE:
```

$ expdp SYSTEM/password SCHEMAS=hr DIRECTORY=dmpdir DUMPFILE=schema_$mydate.dmp LOGFILE=expschema_$mydate.log
```

###### *экспорт всей Database*
```

$ expdp SYSTEM/password full=Y DIRECTORY=dmpdir DUMPFILE=DB_$mydate.dmp LOGFILE=DB_$mydate.log
```


## Data Pump Import

#### В терминале выполняем команду impdp которой передаем что нужно импортировать (в данном примере схему hr), указываем директорию где хранатся файлы дампа, а так же имя DUMPFILE с которого будет производиться дамп и LOGFILE:
```

$ impdp SYSTEM/password schemas=hr directory=dmpdir dumpfile=schema.dmp logfile=impdp_$mydate.log

для смены TABLESPACE (например USERS на HR_TBS ) вконце указываем:

REMAP_TABLESPACE=USERS:HR_TBS
```

###### *импорт всей Database*
```

$ impdp SYSTEM/password full=Y directory=dmpdir dumpfile=schema.dmp logfile=impdp_$mydate.log
```
