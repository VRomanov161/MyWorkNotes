# Linux Commands

## cd - используется для смены каталога (без опций и указания каталога перейдет в домашнюю директорию)
##### $ cd [опции] *папка_назначения*
```
-P # позволяет следовать по символическим ссылкам перед тем, как будут обработаны все переходы ".."
-L # переходит по символическим ссылкам только после того, как были обработаны ".."

cd - переход в предыдущий каталог
cd .. переход в родительский каталог (на уровень выше)
cd / переход в корневой каталог
```

## mkdir - используется для создания новых директорий
##### $ mkdir [опции] *директория*
```

-p # создать все директории, которые указаны внутри пути

EXAMPLES
$ mkdir -p "имя_директории"/"имя_директории"/"имя_директории"
```

## rm - удаление файлов и директорий. По умолчанию команда rm не удаляет директории. Чтобы удалить директорию и все ее содержимое, включая вложенные директории, нужно использовать опцию -r (рекурсивное удаление)

##### $ rm [опции] *файл(ы)*
```

-f # Игнорировать несуществующие файлы и аргументы. Никогда не выдавать запросы на подтверждение удаления
-i # Выводить запрос на подтверждение удаления каждого файла
-r или -R # Удаление директорий и их содержимого. Рекурсивное удаление
```

## cp - утилита позволяет полностью копировать файлы и директории
##### $ cp [опции] *"что_копируем"* *"куда_копируем"*
```

-p # сохранять владельца, временные метки и флаги доступа при копировании
-r # копировать папку Linux рекурсивно
-s # не выполнять копирование файлов в Linux, а создавать символические ссылки
-L # копировать не символические ссылки, а то, на что они указывают
```

## mv - используется что бы переместить (или переименовать) файлы или директории
##### $ mv [опции] *исходные_файлы* *куда*

## who служит для получения информации о пользователях, которые подключены к системе, в том числе и об терминальных сессиях, через которые происходит подключение
##### $ who -a включает в себя все основные опции

## ls - просмотреть содержимое в каталоге, так же выводит информацию о правах на файл
##### $ ls [опции] */путь/к/каталогу/или/файлу*
```
-a # отображать все файлы, включая скрытые
-l # выводить подробный список, в котором будет отображаться владелец, группа, дата создания, размер
-t # сортировать по времени последней модификации
-r # обратный порядок сортировки
-i # отображать номер индекса inode, в которой хранится этот файл
-X # сортировать по алфавиту
```

## alias (псевдоним)
```

$ alias имя="значение"

$ alias имя="команда аргумент1 аргумент2"

$ alias имя="/путь/к/исполняемому/файлу"

$ alias - просмотреть какие заданы псевдонимы
```


## file - позволяет узнать тип данных, которые содержатся внутри документа
##### $ file [опции] *название_документа*

## tar - архиватор
##### $ tar [опции] *архив.tar* *файлы_для_архивации* - для создания архива
##### $ tar [опции] *архив.tar* - для распаковки архива
```
Функции, которые может выполнять команда:
-A	--concatenate	# Присоединить существующий архив к другому
-c	--create	# Создать новый архив
-d	--diff # Проверить различие между архивами
    --delete # Удалить из существующего архива файл
-r	--append	# Присоединить файлы к концу архива
-t	--list	# Сформировать список содержимого архива
-u	--update	# Обновить архив более новыми файлами с тем же именем
-x	--extract	# Извлечь файлы из архива

При определении каждой функции используются параметры,
которые регламентируют выполнение конкретных операций с tar-архивом:

-C dir	--directory=DIR	#Сменить директорию перед выполнением операции на dir
-f file	--file	# Вывести результат в файл (или на устройство) file
-j	--bzip2	# Перенаправить вывод в команду bzip2 (сжать файлы)
-p	--same-permissions	# Сохранить все права доступа к файлу
-v	--verbose	# Выводить подробную информацию процесса
    --totals	# Выводить итоговую информацию завершенного процесса
-z	--gzip	# Перенаправить вывод в команду gzip (сжать файлы)

EXAMPLES

c помощью  команды создается архив archive.tar с подробным выводом информации,
включающий файлы file1, file2 и file3:

$ tar --totals -cvf archive.tar file1 file2 file3

команда выводит содержимое архива, не распаковывая его:

$ tar -tf archive.tar

Распаковывает архив test.tar в текущий каталог с выводом файлов на экран:

$ tar -xvf archive.tar

чтобы распокавать архив в другой каталог:

$ tar -xvf  archive.tar -C /путь/к/каталогу

чтобы создать сжатый архив с помощью bzip2:

$ tar -cjvf archive.tar.bz2 file1 file2 file3

синтаксис для создания зжатого архива gzip:

$ tar -czvf archive.tar.gz file1 file2 file3

для распаковки сжатых архивов в текущую директорию

tar -xzvf archive.tar.gz
или
tar -xjvf arhive.tar.bz2
```
## cat - позволяет просмотреть содержимое файла
##### $ cat [опции] *файл*
```

-b # нумеровать только непустые строки
-n # нумеровать все строки
-s # удалять пустые повторяющиеся строки

EXAMPLES
cat /etc/*-se узнать версию дистрибутива
```


## head - выводит начальные строки (по умолчанию — 10)  из одного или нескольких документов.
##### $ head [опции] *файл*
```

-n "ввести колличество строк" # показывает заданное количество строк вместо 10, которые выводятся по умолчанию
```

## tail - позволяет выводить заданное количество строк с конца файла (по умолчанию 10 последних строк)
##### $ tail [опции] *файл*
```

-f # обновлять информацию по мере появления новых строк в файле
-n # выводить указанное количество строк из конца файла
```

## more - предназначена для постраничного просмотра файлов в терминале Linux
##### $ more [опции] *файл*
```

 у команды more есть собственные горячие клавиши и интерактивные команды:

 ПРОБЕЛ # отображение следующей порции текста (по умолчанию количество строк зависит от текущего размера окна терминала)
 ENTER — вывод текста построчно (шаг команды — одна строка)
 q (Q) — выход из утилиты
```

## less - предназначена для постраничного просмотра больших текстовых файлов
##### $ less [опции] *файл*
```

-N # вывести номера строк
-s # заменить множество идущих подряд пустых строк одной пустой строкой

у команды less есть собственные горячие клавиши и интерактивные команды:

Space # прокрутить текст на один экран вперёд
Enter # прокрутить текст на n строк вперед, по умолчанию n=1
y # прокрутить текст на n строк назад, по умолчанию n=1
q, Q, :q, :Q, ZZ — выход

/текст (для поиска вниз по тексту)
?текст (чтобы выполнить поиск вверх по тексту)
```

## man -  предназначенная для форматирования и вывода справочных страниц
##### $ man *название_команды*

## uname - позволяет узнать текущую версию и дистрибутив используемой операционной системы
##### $ uname [опции]
```

-v  # версия ядра
-r  # релиз ядра
-o  # тип операционной системы
-a  # вся возможная информация
```
## cat /etc/*-release - узнать версию дистрибутива Linux

## touch - команда создает пустой файл. Так же используемая для создания и изменения временных меток файлов.
##### $ touch [опции] *файл1* *файл2* *файл3*
```

-a # изменить только время доступа
-m # изменить только время модификации
-c # не создавать файл, если он не существует
-t # использовать заданные дату и время вместо текущего
    [[CC]YY]MMDDhhmm[.SS]
      MM	Месяц года [01-12]
      DD	День месяца [01-31]
      hh	Час дня [00-23]
      mm	Минута часа [00-59]
      CC	Первые две цифры года
      YY	Последние две цифры года
      SS	Секунда минуты [00-61]
```

## which - отображает полный путь к указанным командам или сценариям
##### $ which *команда*

## chmod — программа для изменения прав доступа к файлам и каталогам
##### $ chmod [опции] [права] */путь/к/файлу*
```

cинтаксис настройки прав такой:
[группа_пользователей действие вид_прав]

-u users
-g group
-o все остальные
- убрать права
+ добавить права
r-read=4
w-write-2
x-execut-1

опции:
-R # изменить права рекурсивно (для директории и всего содержимого)

EXAMPLES

убрать права у пользователя на запись в файл file:

$ chmod u-w file

убрать права на запись для группы:

$ chmod g-w file

добавить права на запись у всех остальных:

$ chmod o+w file

можно задавать параметры для пользователей, групп и всех остальных одной командой:

$ chmod u+rwx,g-x+rw,o-rwx file
```

## stat - выводит информацию о файле
##### $ stat [OPTION] *имя_файла*

## ln - создает жёсткую или символьную ссылку на файл
##### $ ln -s *имя_файла_на_который_будет_создаваться_link* *имя_link* создать SoftLink, по сути это создать ярлык
##### $ ln *имя_файла_на_который_будет_создаваться_link* *имя_link* создать HardLink
```
Ссылка на файл в Linux — это указатель на файл.

Ссылки в Linux бывают двух типов: символические и жесткие.

Символическая ссылка (symbolic link) — это специальный файл, который является ссылкой на другой файл или каталог.
Символические ссылки также называют символьными, мягкими ссылками (soft links).
символическая ссылка не содержит в себе внутри копии самого файла, на которую она указывает. Она является всего лишь указателем на файл. Не смотря на это,
символическая ссылка обладает собственными правами доступа, так как сама является небольшим файлом, который содержит путь до целевого файла.
символические ссылки это своего рода ярлыки на файлы.

Жесткая ссылка (hard link) является своего рода синонимом для существующего файла. Когда вы создаете жесткую ссылку, создается дополнительный указатель на
существующий файл, но не копия файла.
Жесткие ссылки выглядят в файловой структуре как еще один файл. Если вы создаете жесткую ссылку в том же каталоге, где находится целевой файл, то они должны иметь
разные имена. Жесткая ссылка на файл должна находится в той же файловой системе, где и другие жесткие ссылки на этот файл.
```

## useradd  (рекомендуется использовать adduser)- это  утилита, которая используется для добавления/создания пользовательского аккаунта.
##### # useradd [options] *username*


## passwd - задает пароль новому пользователю либо меняет пороль у существующего пользователя
##### # passwd *username*

## id - вывод идентификатора пользователя (UID) и группы. Если пользователь не указан, выдается информация о пользователе, вызвавшем команду.
##### $ id [параметры] *имя_пользователя*

## usermod - изменяет учётную запись пользователя. Команда usermod изменяет системные файлы учётных записей согласно переданным в командной строке параметрам.
##### # usermod [параметры] *LOGIN*
```

-a # добавить пользователя в дополнительную группу(ы). Использовать только вместе с параметром -G
-d # новый домашний каталог пользователя. Если указан параметр -m, то содержимое текущего домашнего каталога будет перемещено в новый домашний каталог, который будет создан, если он ещё не существует
-e # дата, когда учётная запись пользователя будет заблокирована. Дата задаётся в формате ГГГГ-ММ-ДД.
-G # cписок дополнительных групп, в которых числится пользователь. Перечисление групп осуществляется через запятую
Если пользователь — член группы, которой в указанном списке нет, то пользователь
удаляется из этой группы. Такое поведение можно изменить с помощью параметра -a,
при указании которого к уже имеющемуся списку групп пользователя добавляется список указанных дополнительных групп
-l # имя пользователя будет изменено с ИМЯ на НОВОЕ_ИМЯ
-L # заблокировать пароль пользователя. Это делается помещением символа «!» в начало шифрованного пароля, чтобы приводит к блокировке пароля. Не используйте этот параметр вместе с -p или -U
-m # Переместить содержимое домашнего каталога в новое место
Этот параметр можно использовать только с параметром -d (или --home)
-p # ПАРОЛЬ. Шифрованное значение пароля, которое возвращает функция crypt(3).
Замечание: Этот параметр использовать не рекомендуется, так как пароль (или не
шифрованный пароль) будет видим другими пользователям в списке процессов
-U # разблокировать пароль пользователя. Это выполняется удалением символа '!' из начала шифрованного пароля. Не используйте этот параметр вместе с -p или -L

EXAMPLES

добавляет пользователя user в группу wheel:

# usermod -a -G wheel user
```

## chown - утилита для cмены владельца файлов, каталогов и ссылок.
##### $ chown *пользователь* [опции] */путь/к/файлу*
```

-R, --recursive - рекурсивная обработка всех подкаталогов

EXAMPLES

Установить владельца и группу для файла:

# chown user1:group1 file1

изменить владельца папки dir1 на oracle:

# chown oracle /home/oracle/dir1

изменить владельца каталога dir1 и всех подкаталогов на oracle в текущей директории:

# chown -R oracle:oracle ./dir1
```

## grep - утилита grep предназначена для фильтрации выходных данных или поиска определенного слова в файле. РЕГИСТРОЗАВИСИМА!
##### $ <command> [file name] | grep *<string or regular expression>*

##### $ <command>|grep *<string or regular expression>*

##### $ grep *<string or regular expression>* [file name]
```

-i игнорировать регистр

EXAMPLES

выводит данные из file_1 содержание значение ORA

$ cat file_1 | grep ORA

фильтрует вывод команды ps -efl со значением pmon

$ ps -efl | grep pmon
```

## Find - это команда для поиска файлов и каталогов на основе специальных условий
##### find [папка] [параметры] [критерий] [шаблон] [действие]

```

Папка - каталог в котором будем искать

Параметры - дополнительные параметры, например, глубина поиска, и т д

-depth # искать сначала в текущем каталоге, а потом в подкаталогах
-print # выводить полные имена файлов
-type f # искать только файлы
-type d # поиск папки в Linux

Критерий - по какому критерию будем искать: имя, дата создания, права, владелец и т д

-name # поиск файлов по имени
-user # поиск файлов по владельцу
-group # поиск по группе
-mtime # поиск по времени модификации файла
-atime # поиск файлов по дате последнего чтения
-size # поиск файлов в Linux по их размеру

Шаблон - непосредственно значение по которому будем отбирать файлы

Искать файлы по имени (все файлы с расширение .jpg) в текущей директории (.):

$ find . -name "*.jpg"

Не учитывать регистр при поиске по имени:

$ find . -iname "file*"
```
## scp - это утилита, которая работает по протоколу SSH, для передачи файла на компьютер, должен быть запущен SSH сервер, а также необходимо знать логин и пароль для подключения к нему. С помощью команды scp можно не только перемещать файлы между локальной и удаленной системой, но и между двумя удаленными системами.
##### $ scp опции пользователь1@хост1:*/путь/к/файлу/или/директории* пользователь2@хост2:*/путь/куда/копировать/*

если копирование с локальной машины можно не указывать имя локальной машины:

scp опции */путь/к/файлу/или/директории* пользователь2@хост2:*путь/куда/копировать/*


```

-r # рекурсивное копирование директорий
-C # включить сжатие

EXAMPLES

копирование с локальной машины на удаленную машину dns-srv файла file

scp /home/oracle/file oracle@dns-srv:/home/oracle

можно использовать полную запись

scp oracle@oracle-db:/home/oracle/file oracle@dns-srv:/home/oracle
```

## du позволяет вывести размер всех файлов в определённой папке в байтах или в более удобном формате
##### $ du [опции] */путь/к/папке*
```

-a # выводить размер для всех файлов, а не только для директорий, по умолчанию размер выводится только для папок
-c # выводить в конце общий размер всех папок
-h # выводить размер в единицах измерения удобных для человека
```

## df -  позволяет выводить  список подключенных устройств, информацию о занятом месте, а также точку монтирования.
##### $ df [опции] *устройство* - *устройство* указывать необязательно
```
-a # отобразить все файловые системы, в том числе виртуальные, псевдо и недоступные
-h # выводить размеры в читаемом виде, в мегабайтах или гигабайтах
-H # выводить все размеры в гигабайтах
-i # выводить информацию об inode
--total # выводить всю информацию про использованное и доступное место
-T # выводит информацию о файловой системе

```

## lsblk - используется, чтобы узнать информацию о всех блочных устройствах.
##### # lsblk [options] <device>

## free -  осуществляет вывод информации об использовании оперативной памяти
##### $ free [options]
```

-h # выводит информацию в человекочитаемом формате
-m # вывод в мегабайтах
```

## fdisk - утилита для управления разделами диска. Используя fdisk, можно создать новый раздел, удалить или изменить существующий раздел.
##### $ fdisk [опции] <устройство>
```
опции:

-l #- вывести все разделы на выбранных устройствах или если устройств не задано, то на всех устройствах
-w # режим стирания файловой системы или RAID с диска, возможные значения auto, never или always по умолчанию используется auto
-W # режим стирания файловой системы или RAID из только что созданного раздела. Возможные значения аналогичны предыдущей опции

команды:

a # включение или выключения флага boot для раздела
d # удалить раздел
F # показать свободное место
l # вывести список известных типов разделов
n # создать новый раздел
p # вывести таблицу разделов
t # изменение типа раздела
i # вывести информацию о разделе
I и O # записать или загрузить разметку в файл сценария sfdisk
w # записать новую таблицу разделов на диск
q # выйти без сохранения
g # создать пустую таблицу разделов GPT
o # создать пустую таблицу разделов MBR
m # просмотреть доступные команды
```

##  mount - применяется для монтирования файловых систем. С помощью команды mount можно подключить сетевой диск, раздел жесткого диска или USB-накопитель.
##### # mount [файл_устройства] [папка_назначения]
##### # mount [опции] -t [файловая_система] -o [опции_монтирования] [файл_устройства] [папка_назначения]
Опция -t необязательна, но она позволяет задать файловую систему, которая будет использована
```

-v # подробный режим
-a # примонтировать все устройства, описанные в fstab
-f # не выполнять никаких действий, а только посмотреть что собирается делать утилита
-n # не записывать данные о монтировании в /etc/mtab
-r # монтировать раздел только для чтения
-w # монтировать для чтения и записи
-U, --uuid - монтировать раздел по UUID

EXAMPLES

Монтирование sdb6 в /mnt :

$ sudo mount /dev/sdb6 /mnt/
```

##  umount - размонтирование устройств
## unmount *что_отмонтировать_или_указать_каталог_который_хотим_отмонтировать*
```
EXAMPLES

$ sudo umount /mnt/disk1
```

## blkid - выводит UUID разделов

## yum - пакетный менеджер. Предоставляет возможность управления пакетами и репозиториями – установка, обновление, удаление
##### # yum [ключи] [команда] [пакет ...]  
```

вывести список всех пакетов:

yum list all

вывести список доступных для установки пакетов:

yum list available

вывести список установленных пакетов:

yum list installed

вывести список пакетов, добавленных в репозитории за последние 7 дней:

yum list recent

вывести список пакетов, для которых есть обновления:

yum list updates

скачать и установить пакет из репозитория:

yum install [имя_пакета]

переустановка пакета:

yum reinstall [имя_пакета]

обновление указанного пакета:

yum update [имя_пакета]

обновление всех установленных пакетов:

yum update

откат обновления указанного пакета:

yum downgrade [имя_пакета]

удаление установленного пакета из операционной системы:

yum remove [имя_пакета]

список подключенных репозиториев:

yum repolist

информация о репозитории:

yum repoinfo [имя_репозитория]

обновить  информацию о пакетах в  репозитории (скачать метаданные из репозитория в локальное хранилище):

yum check-updates
```

## ps - программа для просмотра списка процессов в Linux
##### $ ps [опции]
```

-e # выбрать все процессы
-с # отображать информацию планировщика
-f # вывести максимум доступных данных
-l # длинный формат вывода
-H - отображать дерево процессов

EXAMPLES

# ps -efl
```

## pstree - отображает дерево процессов.

## top - показывает вывод первых процессов которые потребляют больше всего процессорного времении.
По умолчанию  в реальном времени сортирует процессы по нагрузке на процессор.
```

во время работы утилиты можно задать время обновления данных нажав S
можно вывести информацию о ядрах - нажав 1
load average - выводит информацию о колличестве процессов в очереди на ожидание ресурсов за 1, 5 и 15 ( позволяет определить загруженность системы) если load average  за 1 минуту > чем за 5 и 15 значит нагрузка на сервер возрастает, если меньше, значит нагрузка на сервер падает.
load average < или = колличеству ядер процессора на сервере, тогда сервер работает корректно
третья строчка вывода top :
параметр us (user space) показывает информацию сколько процесорных ресурсов было израсходовано в пространстве пользователя. (все программы которые мы запускаем работают в пространстве пользователя, например сервера которые мы запускаем)
параметр sy (system) показывает сколько процесорного времени было потрачено на работу ядра ОС (в пространстве ядра ОС)
параметр ni (nice) сколько процесорного времени было потрачено на процесы с пониженным приоритетом
параметр id (idle) отображает процес простоя процесорорного времени. на основании данного параметра можно сделать вывод что если load average высокий, а id близится к 100%, то значит дело не в процессоре, так как процессорного времени хватает.
парамет wa (wait) отображает сколько просцессорного времени было потрачено на общение с утройствами ввода-вывода. это означает что процессор ждет ответа с устройства ввода-вывода. если параметр wa растет, значит система ввода-вывода не справляется с текущими потребностями (процессор ждет ответа с сети или например с диска).
параметр hi - сколько процессорных ресурсов было потрачено на обработку апаратных прерываний. Рост данного параметра означает что к серверу подключено устройтво которое посылает прерывания.
параметр si - сколько апаратных прерываний (системных вызовов).
параметр st (интересен для виртуальных машин)- показывает информацию как занята хостовая машина (реальный компьютер, реальное железо). Сколько процентов процессорного времени было украдено с виртуальной машины реальным компьютером. Ну например было выделено одно ядро под виртуальную машину но оно работает на 90% так как реальная машина (хостовой сервер) сильно загружена.
```

## kill - используется для принудительного завершения работы приложений
##### # kill [-SIGNAL] [PID]
```

SIGINT - 2 (Сигнал прерывания (Ctr+c) с терминала)
SIGTERM -15 (Сигнал завершения, сигнал по умолчанию для утилиты kill)
SIGKILL - 9 (Безусловное завершение)
```
## hostname - показать текущее имя хоста.

## ifdown/ifup выключить или включить сетевой интерфейс.
##### # ifup/ifdown [интерфейс]

## host предназначенная для обращения и получения информации DNS-серверов. Позволяет задавать различные типы запросов к системе DNS
##### $ host [параметры] *имя-домена-или-ip-адрес* [имя-сервера-доменных-имен]
```
EXAMPLES

$ host google.com
```

## ping - позволяет проверить доступен удаленный хост или нет.
##### $ ping [опции] адрес_узла
```
EXAMPLES

$ ping google.com
```

## $ sudo hostnamectl set-hostname *новое_имя_хоста* - изменить имя хоста. Еще один способ изменения Hostname — это ручное редактирование файла /etc/hostname и файла /etc/hosts.

## ifconfig используется для настройки сети в операционных системах семейства Linux
##### $ ifconfig [опции] *интерфейс* [команда] <параметры>  <адрес>
```

параметры

up # включить интерфейс
down # выключить интерфейс
netmask # установить маску сети
add # добавить ip адрес для интерфейса
hw # установить MAC адрес для интерфейса

опции

-a # применять команду ко всем интерфейсам
-s # вывести краткий список интерфейсов

EXAMPLES

просмотреть список интерфейсов, подключенных к системе и активированных в данный момент:

 $ sudo ifconfig
```

## ip позволяет посмотреть сетевые интерфейсы и IP адреса им присвоенные, посмотреть и настроить таблицу маршрутизации,
включать или отключать сетевые интерфейсы

##### $ ip [опции] *объект* [команда] [параметры]
```

опции - это глобальные настройки, которые сказываются на работе всей утилиты независимо от других аргументов, их
указывать необязательно

-h # выводить данные в удобном для человека виде
-d # показывать ещё больше подробностей
-o # выводить каждую запись с новой строки
-r # определять имена хостов с помощью DNS
-a # применить команду ко всем объектам
-br # выводить только базовую информацию для удобства чтения

объект - это тип данных, с которым надо будет работать, например: адреса, устройства, таблица arp, таблица маршрутизации
и так далее

address или a - сетевые адреса.
link или l - физическое сетевое устройство.

команды - какое-либо действие с объектом.
основные команды: add, change, del или delete, flush, get, list или show, monitor, replace, restore, save, set, и update.
Если команда не задана, по умолчанию используется *show* (показать).

параметры - позволяет передавать командам параметры

EXAMPLES

узнать информацию об ip адресе, маршруте, сетевого интерфейса

$ ip a
```
## netstat инструмент командной строки для мониторинга как входящих, так и исходящих сетевых подключений.
```
отображает доступные порты по протоколу tcp/ip

$ netstat -tnl

проверить доступность портов ( в данном примере порт 1521)

$ netstat -tulpn | grep 1521

Отображение таблицы IP-маршрутизации ядра

$ netstat -r

Список всех портов (как TCP, так и UDP)

$ netstat -a | more

Список соединений TCP

$ netstat -at

## crontab - планировщик, который позволяет выполнять нужные  скрипты в указанное время
```

посмотреть все задачи cron ДЛЯ ТЕКУЩЕГО ПОЛЬЗОВАТЕЛЯ :

# crontab -l

Для настройки времени, даты и интервала когда нужно выполнять задание используется специальный синтаксис файла cron и
специальная команда:

 # crontab -e

минута час день месяц день_недели /путь/к/исполняемому/файлу
