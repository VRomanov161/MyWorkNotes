## Check if running in ARCHIVELOG mode:
```

SQL> SELECT LOG_MODE FROM V$DATABASE;

SQL> archive log list;
```

## Включить ARCHIVELOG mode

```
SQL> SHUTDOWN IMMEDIATE
	SQL> STARTUP MOUNT
		SQL> ALTER SYSTEM SET LOG_ARCHIVE_DEST_1 = 'LOCATION=/u01/app/oracle/fast_recovery_area/valentin/logfiles';
			SQL> ALTER SYSTEM SET LOG_ARCHIVE_DEST_2 = 'LOCATION=/u01/arch/valentin/logfiles';
				SQL> ALTER DATABASE ARCHIVELOG;
					SQL> ALTER DATABASE OPEN;
						SQL> SHUTDOWN IMMEDIATE;   --Because changing the archiving mode updates the control file, it is recommended that you create a new backup.
							SQL> STARTUP;
```
