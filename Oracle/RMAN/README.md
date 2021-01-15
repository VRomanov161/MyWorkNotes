# RMAN

## RMAN BACKUP INCREMENTAL LEVEL 0

#### Запускаем утилиту rman в терминале и указываем целевую БД:
```

пример аутентификации ОС

$ rman target /
```

#### Выполняем backup
```

RMAN> RUN {
        BACKUP INCREMENTAL LEVEL 0 DATABASE PLUS ARCHIVELOG TAG "LEVEL 0";
        BACKUP CURRENT CONTROLFILE SPFILE;
      }
```

## RMAN BACKUP INCREMENTAL LEVEL 1

#### Запускаем утилиту rman в терминале и указываем целевую БД:
```

пример аутентификации ОС

$ rman target /
```

RMAN> BACKUP INCREMENTAL LEVEL 1 DATABASE PLUS ARCHIVELOG TAG "LEVEL 1";
```

## RMAN RESTORE/RECOVER DATABASE

#### Запускаем утилиту rman в терминале и указываем целевую БД:
```

пример аутентификации ОС

$ rman target /
```

#### Указываем DBID
```

RMAN> SET DBID [ DBID ]
```

#### Запускаем в режиме dammy instance:
```

RMAN> startup force nomount
```

#### Восстанавливаем  SPFILE:
```

RMAN> RESTORE SPFILE FROM '/указываем/путь/до/файла/BACKUP/в/котором/содержится/информация/о/SPFILE';
```

#### Перезапускаем instance with spfile:
```

RMAN> SHUTDOWN IMMEDIATE

RMAN> startup nomount
```

#### Восстанавливаем CONTROLFILE:
```

RMAN> RESTORE CONTROLFILE FROM AUTOBACKUP;
```

#### Монтируем БД:
```

RMAN> alter database mount;
```

#### Полное восстановление

RMAN> restore database;

RMAN> recover database;
```

#### Открываем БД:
```

RMAN> alter database open resetlogs;
```

###### *Если надо восстановться до пределенного  SCN*
```

RMAN> RESTORE CONTROLFILE FROM 'указываем/файл/бекапа/который/содержит/подходящий/SCN';

RMAN> restore database from [ TAG or SCN ]=' указываем TAG or SCN';

RMAN> reset database to incarnation [ указываем incarnation ]; выбираем с подходящим SCN, при необходимости

RMAN> recover database until scn [ указываем scn ];

RMAN> alter database open resetlogs;
```














###### *Вывести информацию о BACKUP:*

```

RMAN> LIST BACKUP OF DATABASE;
or
RMAN> list backup summary;
or
RMAN> LIST BACKUP;
```

###### *Вывести информацию о Incarnations:*

```

RMAN> list incarnation of database;
```

###### *Для добавления временного штампа при выводе LIST BACKUP:*

```
в терминале

$ NLS_DATE_FORMAT="yyyy-mm-dd:hh24:mi:ss"

$ export NLS_DATE_FORMAT="yyyy-mm-dd:hh24:mi:ss"

$ . .bash_profile
```
