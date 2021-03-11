# Моя рабочая NOTE

ЕИАС к БАСОВУ АНДРЕЮ
ПО ИСУСЕ к Зототухин и Золоторев

===================================================================вывести список контейнеров (докер(docker)===========================================================================
Выполняется от root

[root@ebul-swarm-dev-cn02 /]# docker ps

==============================================================connect коннект к контейнеру (докер(docker)=============================================================================
Выполняется от root

[root@ebul-swarm-dev-cn02 /]# docker exec -ti 95f2c41f01fc bash

=============================================================List nodes in the swarm============================================================================================
Вывести список серверов в кластере

[root@ebul-swarm-dev-m01 ~]# docker node ls

============================================================================НАСТРОЙКА СЕТИ=========================================================================
Смотрим все установленные сетевые адаптеры в системе:
ip a

Если нужно настроить сеть для адаптера ens32, открываем на редактирование следующий конфигурационный файл:
#/etc/sysconfig/network-scripts/ifcfg-enp0s3 В нем прописываются сетевые настройки для адаптера интерфейс (например, ifcfg-enp0s3).

TYPE=Ethernet                     # Тип интерфейса
ONBOOT=yes                        # указание на тип запуска сетевого интерфейса. yes автоматически при старте системы, no вручную.
BOOTPROTO=none                    # none или static (статический ip) если  dhcp (динамический ip)
NAME=enp0s3                       # имя сетевого адаптера, оно такое же, как и имя в операционной системе.
DEVICE=enp0s3                     # имя сетевого адаптера, оно такое же, как и имя в операционной системе.
IPADDR=192.168.1.2                # прописываем ip для статического ip  адреса
NETMASK=255.255.255.0             # маска подсети
GATEWAY=192.168.1.1               # IP-адрес сетевого шлюза (моста)
BROADCAST=192.168.1.256           # Широковещательный адрес
HWADDR= 08:00:27:a9:c1:bd         # переменная, хранящая MAC-адрес
NM_CONTROLLED="YES"				  # Указываем, должен ли интерфейс управляться с помощью NetworkManager

Чтобы настройки применились, перезапускаем сетевую службу
#systemctl restart network

для CentOS 8 вводим 2 команды:

#systemctl restart NetworkManager


* в большей степени, это основное отличие версий 7 и 8. Чтобы команды смогли поменять настройки, для интерфейсов необходима настройка NM_CONTROLLED=yes.

#/etc/sysconfig/network. В нем описываются сетевые настройки, касающиеся сетевого имени хоста и шлюза по умолчанию. Сетевое имя хоста прописывается в HOSTNAME, шлюз по умолчанию – в GATEWAY.
NETWORKING=YES
GATEWAY=192.168.1.1


# /etc/resolv.conf    хранится информация о DNS сервере
   nameserver 8.8.8.8
   search Список для поиска имен машин. используется для resolva имен по короткому имени (указывается зона, например valentin.ru)
#ifdown ifcfg-enp0s3 И ifup ifcfg-enp0s3 выключить или включить сетевой интерфейс

# host google.com Получение IP-адреса сервера по имени домена либо наоборот
# hostname показать текущее имя хоста
# sudo hostnamectl set-hostname новое_имя_хоста     - изменить имя хоста. Еще один способ изменения Hostname — это ручное редактирование файла /etc/hostname и файла /etc/hosts.


==================================================firewall======================================

#systemctl stop/start firewalld - остановить/запустить службу firewall
#systemctl status firewalld -узнать статус
#systemctl enable firewalld -Добавить в автозапуск
#systemctl disable firewalld -Убрать из автозапуска

==============================================================================настройка и установка сервиса DNS BIND============================================================
# установть bind на dns сервер
yum install bind bind-utils
#настройка основного DNS сервера
# открыть в текстовом редакторе файл /etc/named.conf и внести изменения:
	Над существующим блоком + options + создайте новый блок ACL, который называется «доверенный». Здесь мы определим список клиентов, которым мы будем разрешать рекурсивные DNS-запросы (т.е. ваши серверы, которые находятся в том же центре обработки данных, что и dns server (ip 192.168.1.3))

		acl "trusted" {
        192.168.1.3;
        192.168.1.2;
		192.168.1.68;
};

	Теперь, когда у нас есть список доверенных DNS-клиентов, нам нужно отредактировать блок + options +. Добавьте частный IP-адрес (dns server (ip 192.168.1.3)) в директиву + listen-on port 53 + и закомментируйте строку + listen-on-v6 + и внести изменения следующие изменения :

		options {

        listen-on port 53 { 127.0.0.1; 192.168.1.3; };   ######
        // listen-on-v6 port 53 { ::1; };                ######
		directory       "/var/named";
        dump-file       "/var/named/data/cache_dump.db";
        statistics-file "/var/named/data/named_stats.txt";
        memstatistics-file "/var/named/data/named_mem_stats.txt";
        recursing-file  "/var/named/data/named.recursing";
        secroots-file   "/var/named/data/named.secroots";
        allow-query     { any; };                        #########
		 recursion yes;
        forwarders {                                     ########
                8.8.8.8;
                8.8.4.4;
        };
        forward only;
        dnssec-enable yes;
        dnssec-validation yes;

        /* Path to ISC DLV key */
        bindkeys-file "/etc/named.root.key";

        managed-keys-directory "/var/named/dynamic";

        pid-file "/run/named/named.pid";
        session-keyfile "/run/named/session.key";
};

logging {
        channel default_debug {
                file "data/named.run";
                severity dynamic;
        };
};

zone "." IN {
        type hint;
        file "named.ca";
};

include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";
include "/etc/named/named.conf.local";          #################  добавляем эту строку-путь к файлам

#####Настроить локальный файл#######
открываем файл для редактирвоания /etc/named/named.conf.local, Файл должен быть пустым. Здесь мы укажем нашу прямую и обратную зоны.

Добавьте прямую зону следующими строками (замените имя зоны своим):

zone "valentin.ru" {
        type master;
        file "/etc/named/zones/db.valentin.ru";
};


добавьте обратную зону с помощью следующих строк

zone "168.192.in-addr.arpa" {                                       ######Предполагая, что наша частная подсеть 192.168.1.0
        type master;
        file "/etc/named/zones/db.192.168";
};

Теперь, когда наши зоны указаны в BIND, нам нужно создать соответствующие файлы прямой и обратной зон.
###Создать файл прямой зоны
Файл прямой зоны - это место, где мы определяем записи DNS для прямого поиска DNS.
Давайте создадим каталог, в котором будут находиться наши файлы зон. Согласно нашей конфигурации named.conf.local, это расположение должно быть + / etc / named / zones +:
	mkdir /etc/named/zones
Теперь давайте отредактируем наш файл прямой зоны:
   /etc/named/zones/db.valentin.ru

$TTL    604800
@       IN      SOA     valentin.ru. admin.valentin.ru. (
              2        ; Serial                ##### Каждый раз, когда вы редактируете файл зоны, вы должны увеличивать значение serial, прежде чем перезапускать процесс + named +
            604800     ; Refresh
             86400     ; Retry
           2419200     ; Expire
            604800 )   ; Negative Cache TTL

; name servers - NS records
   IN      NS      dns-srv                      ##### указываем DNS-server

; name servers - A records
dns-srv        IN      A  192.168.1.3           #### указываем DNS-server и его ip
oracle-db      IN      A  192.168.1.2           #### указываем клиенты (хосты) и их ip

#########Создать файл обратной зоны
	/etc/named/zones/db.192.168

$TTL    604800
@       IN      SOA     db.valentin.ru admin.db.valentin.ru. (                  ### указываем полное доменное имя
              2        ; Serial
            604800     ; Refresh
             86400     ; Retry
           2419200     ; Expire
            604800 )   ; Negative Cache TTL

; name servers - NS records
   IN      NS      dns-srv.valentin.ru.                                       ###  указываем DNS-server      

; name servers - PTR Records                                                  ###  указывается только последние два октета ip в одбартном порядке (пример для ip 192.168.1.3)
3.1      IN      PTR  dns-srv.valentin.ru.                                    ###  указываем DNS server            
2.1      IN      PTR  oracle-db.valentin.ru.	                              ### указываем клиенты (хосты) и их ip  

Файл обратной зоны - это место, где мы определяем записи DNS PTR для обратного поиска DNS.
##########SOA (Start of Authority/начальная запись зоны) — описывает основные/начальные настройки зоны, можно сказать, определяет зону ответственности данного сервера. Для каждой зоны должна существовать только одна запись SOA и она должна быть первая. Поле Name содержит имя домена/зоны, поля TTL, CLASS — стандартное значение, поле TYPE принимает значение SOA, а поле DATA состоит из нескольких значений, разделенных пробелами: имя главного DNS (Primary Name Server), адрес администратора зоны, далее в скобках — серийный номер файла зоны (Serial number). При каждом внесении изменений в файл зоны данное значение необходимо увеличивать, это указывает вторичным серверам, что зона изменена, и что им необходимо обновить у себя зону. Далее — значения таймеров (Refresh — указывает, как часто вторичные серверы должны опрашивать первичный, чтобы узнать, не увеличился ли серийный номер зоны, Retry — время ожидания после неудачной попытки опроса, Expire — максимальное время, в течение которого вторичный сервер может использовать информацию о полученной зоне, Minimum TTL — минимальное время, в течение которого данные остаются в кэше вторичного сервера).
Запись ресурса состоит из следующих полей:

имя (NAME) — доменное имя, к которому привязана или которому «принадлежит» данная ресурсная запись, либо IP адрес. При отсутствии данного поля, запись ресурса наследуется от предыдущей записи.
Time To Live (TTL) — дословно «время жизни» записи, время хранения записи в кэше DNS (после указанного времени запись удаляется), данное поле может не указываться в индивидуальных записях ресурсов, но тогда оно должно быть указано в начале файла зоны и будет наследоваться всеми записями.
класс (CLASS) — определяет тип сети, (в 99,99% случаях используется IN (что обозначает — Internet). Данное поле было создано из предположения, что DNS может работать и в других типах сетей, кроме TCP/IP)
тип (TYPE) — тип записи синтаксис и назначение записи
данные (DATA) — различная информация, формат и синтаксис которой определяется типом.

При этом, возможно использовать следующие символы:
;   -  Вводит комментарий
#  -  Также вводит комментарии (только в версии BIND 4.9)
@  — Имя текущего домена
( )    — Позволяют данным занимать несколько строк
*    — Метасимвол (только в поле имя)

СНаиболее часто применяемые ресурсные записи следующими (далее, мы обязательно рассмотрим их на практике):
A — (address record/запись адреса) отображают имя хоста (доменное имя) на адрес IPv4. Для каждого сетевого интерфейса машины должна быть сделана одна A-запись.
AAAA (IPv6 address record) аналогична записи A, но для IPv6.
CNAME (canonical name record/каноническая запись имени (псевдоним)) — отображает алиас на реальное имя (для перенаправления на другое имя), н
MX (mail exchange) — указывает хосты для доставки почты, адресованной домену. При этом поле NAME указывает домен назначения, поля TTL, CLASS — стандартное значение, поле TYPE принимает значение MX, а поле DATA указывает приоритет и через пробел - доменное имя хоста, ответственного за прием почты. Например, следующая запись показывает, что для домена k-max.name направлять почту сначала на mx.k-max.name, затем на mx2.k-max.name, если с mx.k-max.name возникли какие-то проблемы. При этом, для обоих MX хостов должны быть соответствующие A-записи:
NS (name server/сервер имён) указывает на DNS-сервер, обслуживающий данный домен. Вернее будет сказать — указывают сервера, на которые делегирован данный домен. Если записи NS относятся к серверам имен для текущей зоны, доменная система имен их практически не использует. Они просто поясняют, как организована зона и какие машины играют ключевую роль в обеспечении сервиса имен.
PTR (pointer) — отображает IP-адрес в доменное имя (о данном типе записи поговорим ниже в разделе обратного преобразования имен).
#####Проверьте синтаксис конфигурации BIND
Выполните следующую команду, чтобы проверить синтаксис файлов + named.conf * +:
sudo named-checkconf
Если в ваших именованных файлах конфигурации нет синтаксических ошибок, вы вернетесь к приглашению оболочки и не увидите сообщений об ошибках.
####Начать BIND:
sudo systemctl start named
Теперь вы захотите включить его, чтобы он запускался при загрузке:
sudo systemctl enable named
######Настройте DNS-клиенты
Прежде чем все ваши серверы в «доверенном» ACL-списке смогут запрашивать ваши DNS-серверы, вы должны настроить каждый из них для использования ранее настоенного сервера в качестве серверов имен. Этот процесс варьируется в зависимости от ОС, но для большинства дистрибутивов Linux он включает добавление ваших серверов имен в файл + / etc / resolv.conf +.
Клиенты CentOS
В CentOS, RedHat и Fedora Linux VPS просто отредактируйте файл + resolv.conf +:
sudo vi /etc/resolv.conf
Затем добавьте следующие строки в начало файла (замените свой частный домен и ns1 и ns2 частные IP-адреса):
/etc/resolv.conf
search   # your private domain
nameserver 192.168.1.3  # DNS IP address
Теперь сохраните и выйдите. Ваш клиент теперь настроен на использование ваших DNS-серверов.

=========================================================НАСТРОЙКА SSH KEY===============================================================================
# На стороне клиента генерируем приватный и публичный ключи
# ssh-keygen далее либо жмем некст некст некст, либо самостоятельно выбираем пусть куда сохраняться ключи а так же можно задать пароль для ключей
# ssh-copy-id имя_пользователя@host(либо ip удаленного сервера)
ключи по умолчанию копируются и создаются в домашней директории пользователя в скрытой папке .ssh
# для повышения securiti (безопасности) на сервере можно запретить доступ подключения по ssh при помощи пароля:
	для этого редактируем файл на сервере:
	/etc/ssh/sshd_config
		PasswordAuthentication yes(разрешен доступ при помощи пароля) no (запрещен) после изменений нужно перезапустить сервис ssh
	та кже можно запретить подключаться по shh к серверу пользователю root
		PermitRootLogin yes no
	список пользователей которым разрешен доступ по ssh содержится в AllowUsers

===========================================ДОБАВЛЕНИЕ И МОНТИРОВАНИЕ ДИСКА====================================================================================

С помощью команды fdisk -l необходимо посмотреть какие диски доступны для монтирования (при необходимости, можно добавить диск в virtual box)
Теперь с помощью команды fdisk разобьем диск на разделы, например fdisk /dev/sdb     так мы попадаем в меню управления утилиты fdisk
Далее выполните команды в интерфейсе утилиты fdisk. Создаем раздел с помощью опции n (можно разбить диск на разделы,  если Вы хотите выбрать значение по умолчанию, то нажмите Enter)
Выводим созданные разделы на экран для проверки, с помощью опции p.
Необходимо сохранить внесенные изменения с помощью опции w.
Теперь на разделах необходимо создать файловую систему с помощью утилиты mkfs, указав после точки тип файловой системы:
# mkfs.ext4 /dev/sdb (если разделов несколько, то для каждого раздела)
Далее необходимо создать точку монтирования для каждого раздела:
# mkdir /disrib
Для автоматического монтирования разделов после перезагрузки сервера внесите изменения в файл /etc/fstab с помощью текстового редактора
vi /etc/fstab
	/dev/sdb /distrib ext4 defaults 0 0
С помощью команды mount монтируем разделы:
mount -a

=================================================Установка и Настройка NFS сервера и клиента==========================================================================================
#НА стороне сервера
	# yum install nfs-utils
	  После установки нужных пакетов, нужно запустить службы nfs-server и rpcbind, добавьте их в автозагрузку:
	# systemctl enable rpcbind
	# systemctl enable nfs-server
	# systemctl start rpcbind
	# systemctl start nfs-server
		Если у вас в системе установлен firewalld откройте необходимые порты:
		# firewall-cmd --permanent --add-port=111/tcp
		# firewall-cmd --permanent --add-port=20048/tcp
		# firewall-cmd --permanent --zone=public --add-service=nfs
		# firewall-cmd --permanent --zone=public --add-service=mountd
		# firewall-cmd --permanent --zone=public --add-service=rpc-bind
		# firewall-cmd --reload
	Теперь создадим директорию, которая будет раздаваться вашим NFS сервером:
	# mkdir -p /nfs
	# chmod -R 777 /nfs
	Теперь в конфигурационном файле с настройками NFS сервера (/etc/exports) нужно опубликовать данный каталог и назначить права доступа.
	# vi /etc/exports
	Добавьте в файл следующую строку для предоставления доступа к NFS всем хостам в указанной IP подсети:
	/nfs 192.168.1.0/24(rw,sync,no_root_squash,no_all_squash)
	Или можно ограничить доступ для конкретного IP:
	/backup/nfs 192.168.2.24(rw,sync,no_root_squash,no_all_squash, anonuid=1000,anongid=1000) 192.168.3.100(ro,async,no_subtree_check)
	Рассмотрим более подробно формат предоставления прав к NFS каталогу:
		rw – права на запись в каталоге, ro – доступ только на чтение;
		sync – синхронный режим доступа. async – подразумевает, что не нужно ожидать подтверждения записи на диск (повышает производительность NFS, но уменьшает надежность);
		no_root_squash – разрешает root пользователю с клиента получать доступ к NFS каталогу (обычно не рекомендуется);
		no_all_squash — включение авторизации пользователя. all_squash – доступ к ресурсам от анонимного пользователя;
		no_subtree_check – отключить проверку, что пользователь обращается в файлу в определенном каталоге (subtree_check – используется по умолчанию);
		anonuid, anongid – сопоставить NFS пользователю/группу указанному локальному пользователю/группе(UID и GID).
	Чтобы применить новые настройки NFS каталогов, выполните:
	# exportfs -a
	И перезапустите nfs-сервер:
	# systemctl restart nfs-server
	На этом установка и настройка nfs-сервера закончена и можно приступить к настройке клиента.
#На стороне клиента:
Для настройки NFS клиента, нужно также установить пакет nfs-utils. Для CentOS 7:
	# yum install nfs-utils
	Добавляем сервисы в автозагрузку и включаем:
	# systemctl enable rpcbind
	# systemctl enable nfs-server
	# systemctl start rpcbind
	# systemctl start nfs-server
	Теперь на клиенте, нужно создать директорию, в которую мы смонтируем nfs-каталог:
	# mkdir /nfs
	Теперь можно смонтировать удаленное NFS-хранилище командой:
	# mount -t nfs 192.168.1.3:/nfs /nfs
		можно принудительно указать версию NFS протокола, которую нужно использовать
		# mount -t nfs -o vers=4 192.168.1.3:/nfs /backup
	Где IP — это адрес NFS-сервера, который вы настроили ранее.
Чтобы NFS каталог автоматически монтировался при перезагрузке, нужно открыть файл fstab:
# vi /etc/fstab
И добавьте строку:
192.168.1.3:/nfs /nfs nfs rw,sync,hard,intr 0 0
После сохранения файла fstab, можно применить его командой:
# mount -a

=======================================================НАСТРОЙКА и УСТАНОВКА NTP СЕРВЕРА============================================

# yum install ntp
https://www.pool.ntp.org/en/ выбрать нужный пул
откройте основной конфигурационный файл для редактирования списка серверов с pool.ntp.org проекта и нужно заменить его на Ваши пулы
# vim /etc/ntp.conf
	[...]
	server 0.ru.pool.ntp.org
	server 1.ru.pool.ntp.org
	server 2.ru.pool.ntp.org
	server 3.ru.pool.ntp.org
	[...]
 Кроме того, необходимо позволить клиентам из вашей сети синхронизировать время с сервером. Для этого добавьте следующую строку в файл конфигурации NTP, где  есть ограничения управления. Замените данный IP и маску на Вашу, соответственно:
 restrict 192.168.1.0 netmask 255.255.255.0 nomodify notrap
Добавление правил в Firewall и запуск NTP демона.
	# firewall-cmd --add-service=ntp --permanent
	# firewall-cmd --reload
		# systemctl start ntpd - старт сервера
			# systemctl enable ntpd - добавление в автозагрузку

===========================================================================РАБОТА С ДИСКАМИ (logical volume manager)=============================================

Перед использованием диска или раздела в качестве физического тома необходимо его инициализировать:
	Для целого диска:
		# pvcreate /dev/hdb Эта команда создает в начале диска дескриптор группы томов.
# pvs -вывести список физичесиких томов (PV)
	# pvdisplay - вывевести подробную инфомрацию о физических томах (PV)
Для создания группы томов (VG) используется команда 'vgcreate'
	# vgcreate имя_группы /dev/hdb
		# vgdisplay - вывевести подробную инфомрацию о  группе томов (VG)
			#vgs
Для того, чтобы создать логический том (LV) "lv00", размером 1500Мб, в группе томов "vg00" выполните команду:
	# lvcreate -L1500 -nlv00 vg00
		# lvdisplay - вывевести подробную инфомрацию о логических томах (LV)
			#lvs
создание файловой системы ext4 для логического тома oracle_app_lv1 в группе томов oracle_app_vg
mkfs.ext4 /dev/oracle_app_vg/oracle_app_lv1
			далее монитуем и можно пользоваться
Для увеличения логического тома вам нужно просто указать команде lvextend до какого размера вы хотите увеличить том:
	# lvextend -L12G /dev/vg00/home   В результате /dev/vg00/home увеличится до 12Гбайт.
		# lvextend -L+1G /dev/vg00/home Эта команда увеличивает размер логического тома на 1Гб
			После того как вы увеличили логический том, необходимо соответственно увеличить размер файловой системы
				для файловой системы ext2 +
					Если вы не пропатчили ваше ядро патчем ext2online, вам будет необходимо размонтировать файловую систему перед изменением размера:
						# umount /dev/vg00/home
						# resize2fs /dev/vg00/home
						# mount /dev/vg00/home /home
# df -T определить файловую систему для смонтированных разделов
Для добавления предварительно инициализированного физического (PV) тома в существующую группу томов используется команда 'vgextend':
# vgextend vg00 /dev/hdc1
    старый^^^^   ^^^^^^ новый физический том


1. DDL разобрать индексы
2. создать индексы
2. проверить, если внести изменения в представления, изменения коснуться базовой таблицы
4. A typical data warehouse has two important components: dimensions and facts.
5. Рекомпиляцию invalid objects;
6. Почитать про табличные пространства!!!
7. КРОНТАБ





set linesize 300
set pagesize 300
select segment_name, segment_type from dba_segments where owner='HR';




select owner, table_name, index_name,




====================================Посмотреть, какие табличные пространства имеются в базе данных можно следующим запросом=========================================================

SQL> select TABLESPACE_NAME from dba_tablespaces;


=================================================В каких файлах хранятся табличные пространства.==================================================================================

SQL> select file_name, tablespace_name FROM DBA_DATA_FILES;

===================================================ВЫВЕСТИ ИНФОРМАЦИЮ об ИНДЕКСАХ==============================================

set pages 999
break on table_name skip 2
column table_name  format a40
column index_name  format a40
column column_name format a40
select
   table_name,
   index_name,
   column_name
from
   dba_ind_columns
where
   table_owner='HR' and table_name='LOCATIONS'
order by
   table_name,
   column_position;
=====================================================================  == =
select i.table_name,
       i.index_name,
       u.constraint_type
from   dba_constraints u,
       dba_indexes i
where  i.owner = 'HR'
and    i.table_name = u.table_name
and    i.index_name = u.index_name
/
=====================================================Просмотреть план выполнения SQL Запроса===================================================
EXPLAIN Plan for SELECT * from table; -- обьяснить план для запроса "SELECT * from table"

set lines 300 pages 0
SELECT * FROM table (DBMS_XPLAN.DISPLAY); -- вывести объясненный выше план
========================================================================= ПОКАЗАТЬ СТРУКТУРУ DDL==========================================================
set heading off;
set echo off;
Set pages 999;
set long 90000;
spool ddl_list.sql
select dbms_metadata.get_ddl('INDEX','EMP_EMAIL_UK','HR') from dual;
spool off;




set heading off;
set echo off;
Set pages 999;
set long 90000;
select dbms_metadata.get_ddl('PROCEDURE','SECURE_DML','HR') from dual;


======================================================================================================================================================================


@?/demo/schema/mksample oracle oracle welcome1 welcome1 welcome1 welcome1 welcome1 welcome1 USERS TEMP /u01/app/oracle/product/12.2.0/dbhome_1/demo/schema/log/ oracle-db.valentin.ru:1521/valentin





===============================================================Checking the Database Instance Status========================================================

SQL> select instance_name, status from V$instance;


============================================================ Check if running in ARCHIVELOG mode ( проверить включен или выключен режим ARCHIVELOG ) ================================

SQL> SELECT LOG_MODE FROM V$DATABASE;

SQL> archive log list;

====================================================================включить ARCHIVELOG mode=======================================================================================

SQL> SHUTDOWN IMMEDIATE
	SQL> STARTUP MOUNT
		SQL> ALTER SYSTEM SET LOG_ARCHIVE_DEST_1 = 'LOCATION=/u01/app/oracle/fast_recovery_area/valentin/logfiles';
			SQL> ALTER SYSTEM SET LOG_ARCHIVE_DEST_2 = 'LOCATION=/u01/arch/valentin/logfiles';
				SQL> ALTER DATABASE ARCHIVELOG;
					SQL> ALTER DATABASE OPEN;
						SQL> SHUTDOWN IMMEDIATE;   --Because changing the archiving mode updates the control file, it is recommended that you create a new backup.
							SQL> STARTUP;




======================================DROP USER (удаление схемы)======================================================================================================
SQL> DROP USER user CASCADE;
	#где user это имя схемы
		#если в схеме есть обьекты, CASCADE указывает на удаление всех обектов в схеме

==================================================================УЗНАТЬ GLOBAL_NAME==========================================================================================

SQL> SELECT * FROM global_name;

=======================================================================Узнать пользователя текущей сессии==========================================================

SQL> show user


============================================================ UNLOCK ACCOUNT (разблокировать акаунт)=================================================================================

ERROR: ORA-28000: the account is locked
SOLUTION:	SQL > ALTER USER SYSTEM ACCOUNT UNLOCK; где SYSTEM = имя пользователя

=============================================================CHANGE PASSWORD (сменить пароль)=================================================================================

ERROR: ORA-01017: invalid username/password; logon denied
SOLUTION: SQL > ALTER USER SYSTEM IDENTIFIED BY oracle; где SYSTEM = имя пользователя

===========================================================СКОЛЬКО ОБЪЕКТОВ В СХЕМЕ по типам==================================================================================
set linesize 300 pagesize 300
col owner for a10
col OBJECT_TYPE for a20
break on owner skip 1
select owner, OBJECT_TYPE, count(*) from dba_objects where owner in ('HR', 'OE', 'PM', 'IX', 'SH', 'BI') group by owner, object_Type order by owner;

============================================================================CREATE TABLESPACE (создать таблинчое пространство)=======================================================

SQL> CREATE TABLESPACE HR_TBS DATAFILE 'HR_TBS.dbf' SIZE 500m AUTOEXTEND ON NEXT 50M MAXSIZE UNLIMITED;

=====================================================================Вывести информацию о расположении DATAFILE====================================================================

SELECT NAME,
    FILE#,
    STATUS,
    CHECKPOINT_CHANGE# "CHECKPOINT"   
  FROM   V$DATAFILE;
=========================================другой способ
SQL> select FILE_NAME, FILE_ID, TABLESPACE_NAME, ONLINE_STATUS from DBA_DATA_FILES;

====================================================================DATA PUMP=============================================================
======================================================ЭКСПОРТ

# mkdir -p /u03/oradata/datapump/dumps     #создаем в терминале директорию куда будет производится экспорт, можно и одну общую   mkdir /usr/lib/oracle/xe/tmp
# mkdir -p /u03/oradata/datapump/logs
	# chown -R oracle:dba /u03/oradata/datapump/dumps     #меняем группы пользователей
	# chown -R oracle:dba /u03/oradata/datapump/logs
		#далее создаем  ссылки в базе данных на каталоги операционной системы, которые создали ранее
			SQL> CREATE OR REPLACE DIRECTORY dpdumps as '/u01/arch/datapump/dumps';
			SQL> CREATE OR REPLACE DIRECTORY dplogs as '/u01/arch/datapump/logs';
				Посмотреть уже имеющиеся каталоги для datapump:
					set linesize 200
					set pagesize 0
					col directory_name format a30
					col directory_path format a60
					select directory_name, directory_path from dba_directories;
				можно задать один каталог если ранее задавали один каталог для файлов данных и логов
					SQL>CREATE OR REPLACE DIRECTORY dmpdir AS '/usr/lib/oracle/xe/tmp';
		#В терминале задаем переменую времени по необходимости
			mydate=`date "+%H.%M_%d.%m.%Y"`
			expdp SYSTEM/oracle SCHEMAS=HR dumpfile=dpdumps:HR_$mydate.dmp logfile=dplogs:HR_$mydate.log скрипт для экспорта если задавались раздельные каталоги
				expdp SYSTEM/password SCHEMAS=hr DIRECTORY=dmpdir DUMPFILE=schema.dmp LOGFILE=expschema.log если один каталоги

==========================================ИМПОРТ
impdp SYSTEM/oracle SCHEMAS=HR dumpfile=dpdumps:HR_13.42_17.12.2020.dmp logfile=dplogs:imp_HR_$mydate.log REMAP_TABLESPACE=USERS:HR_TBS
	dpdumps указываем файл с которого хотим сделать импорт
	REMAP_TABLESPACE=USERS:HR_TBS   меняем табличное пространство USERS на HR_TBS

===========================================================================(FIND) Identifying Invalid Objects====================================================================

COLUMN object_name FORMAT A30
SELECT owner,
       object_type,
       object_name,
       status
FROM   dba_objects
WHERE  status = 'INVALID'
ORDER BY owner, object_type, object_name;

================================================
SOLUTION:
ALTER PACKAGE my_package COMPILE;
ALTER PACKAGE my_package COMPILE BODY;
ALTER PROCEDURE my_procedure COMPILE;
ALTER FUNCTION my_function COMPILE;
ALTER TRIGGER my_trigger COMPILE;
ALTER VIEW my_view COMPILE;
===============================================
EXEC UTL_RECOMP.recomp_parallel(4);        -- for all database scan and then compile


=========================================================UPDATE TABLE (вставка нового значниения в таблицу)=========================================================================

UPDATE HR.DEP_LOC
   SET DEPARTMENT_NAME='ZALUPA'
   WHERE DEPARTMENT_ID='10';

   --HR.DEP_LOC       имя таблицы
   --DEPARTMENT_NAME  столбец
   --DEPARTMENT_ID    строка

==================================================================TASK==========================================================================================
1. Написать  запрос c JOIN двух таблиц схемы HR: DEPARTMENTS и LOCATIONS, который будет выводить столбцы DEPARTMENT_ID,DEPARTMENT_NAME,LOCATION_ID,STATE_PROVINCE и все строки (т.е. без предиката where)
2. На основе запроса выше создать VIEW в схеме HR с именем DEP_LOC
3. Проверить , что VIEW выводить результат (сохранить все выводы в нотку, чтоб я могу проверить)
4. Дропнуть таблицу DEPARTMENTS.
5. Попробовать выполнить шаг 3 - полученную ошибку сохранить в нотку
6. проверить что в DBA_OBJECTS статус VIEW стал INVALID
7. попробовать скомпилировать VIEW - полуенную ошибку сохранить
8. импортировать таблицу DEPARTMENTS обратно в схему HR
9. повторить шаги 7,6 ( статус должен  стать VALID), 3
===========================================================================================
==============================================================================1. JOIN двух таблиц схемы HR===========================================

Select HR.DEPARTMENTS.DEPARTMENT_ID, HR.DEPARTMENTS.DEPARTMENT_NAME, HR.DEPARTMENTS.LOCATION_ID, HR.LOCATIONS.STATE_PROVINCE
from HR.DEPARTMENTS
INNER JOIN HR.LOCATIONS
ON HR.DEPARTMENTS.LOCATION_ID=HR.LOCATIONS.LOCATION_ID
ORDER BY DEPARTMENT_ID;
=============================вариант 2

Select dep.DEPARTMENT_ID, dep.DEPARTMENT_NAME, dep.LOCATION_ID, loc.STATE_PROVINCE
from HR.DEPARTMENTS dep
JOIN HR.LOCATIONS loc
ON dep.LOCATION_ID=loc.LOCATION_ID
ORDER BY DEPARTMENT_ID;


=========================================================================================================================================================
//////////////////////////////////////////////////////////////////////////////////////////
DEPARTMENT_ID DEPARTMENT_NAME                LOCATION_ID STATE_PROVINCE
------------- ------------------------------ ----------- -------------------------
           10 Administration                        1700 Washington
           20 Marketing                             1800 Ontario
           30 Purchasing                            1700 Washington
           40 Human Resources                       2400
           50 Shipping                              1500 California
           60 IT                                    1400 Texas
           70 Public Relations                      2700 Bavaria
           80 Sales                                 2500 Oxford
           90 Executive                             1700 Washington
          100 Finance                               1700 Washington
          110 Accounting                            1700 Washington
          120 Treasury                              1700 Washington
          130 Corporate Tax                         1700 Washington
          140 Control And Credit                    1700 Washington
          150 Shareholder Services                  1700 Washington
          160 Benefits                              1700 Washington
          170 Manufacturing                         1700 Washington
          180 Construction                          1700 Washington
          190 Contracting                           1700 Washington
          200 Operations                            1700 Washington
          210 IT Support                            1700 Washington
          220 NOC                                   1700 Washington
          230 IT Helpdesk                           1700 Washington
          240 Government Sales                      1700 Washington
          250 Retail Sales                          1700 Washington
          260 Recruiting                            1700 Washington
          270 Payroll                               1700 Washington

27 rows selected.
//////////////////////////////////////////////////////////////////////////////

=========================================================================CREATE VIEW (ПРЕДСТАВЛЕНИЕ)==================================================================
2. На основе запроса выше создать VIEW в схеме HR с именем DEP_LOC

CREATE VIEW HR.DEP_LOC AS
Select HR.DEPARTMENTS.DEPARTMENT_ID, HR.DEPARTMENTS.DEPARTMENT_NAME, HR.DEPARTMENTS.LOCATION_ID, HR.LOCATIONS.STATE_PROVINCE
from HR.DEPARTMENTS
INNER JOIN HR.LOCATIONS
ON HR.DEPARTMENTS.LOCATION_ID=HR.LOCATIONS.LOCATION_ID
ORDER BY DEPARTMENT_ID;

=======================================================================================================================================================================
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
SQL> desc HR.DEP_LOC;
 Name                                                                                                              Null?    Type
 ----------------------------------------------------------------------------------------------------------------- -------- ----------------------------------------------------------------------------
 DEPARTMENT_ID                                                                                                     NOT NULL NUMBER(4)
 DEPARTMENT_NAME                                                                                                   NOT NULL VARCHAR2(30)
 LOCATION_ID                                                                                                                NUMBER(4)
 STATE_PROVINCE                                                                                                             VARCHAR2(25)
 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

3. Проверить , что VIEW выводить результат (сохранить все выводы в нотку, чтоб я могу проверить)

Select DEPARTMENT_ID, DEPARTMENT_NAME, LOCATION_ID, STATE_PROVINCE
from HR.DEP_LOC
ORDER BY DEPARTMENT_ID;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
DEPARTMENT_ID DEPARTMENT_NAME                LOCATION_ID STATE_PROVINCE
------------- ------------------------------ ----------- -------------------------
           10 Administration                        1700 Washington
           20 Marketing                             1800 Ontario
           30 Purchasing                            1700 Washington
           40 Human Resources                       2400
           50 Shipping                              1500 California
           60 IT                                    1400 Texas
           70 Public Relations                      2700 Bavaria
           80 Sales                                 2500 Oxford
           90 Executive                             1700 Washington
          100 Finance                               1700 Washington
          110 Accounting                            1700 Washington
          120 Treasury                              1700 Washington
          130 Corporate Tax                         1700 Washington
          140 Control And Credit                    1700 Washington
          150 Shareholder Services                  1700 Washington
          160 Benefits                              1700 Washington
          170 Manufacturing                         1700 Washington
          180 Construction                          1700 Washington
          190 Contracting                           1700 Washington
          200 Operations                            1700 Washington
          210 IT Support                            1700 Washington
          220 NOC                                   1700 Washington
          230 IT Helpdesk                           1700 Washington
          240 Government Sales                      1700 Washington
          250 Retail Sales                          1700 Washington
          260 Recruiting                            1700 Washington
          270 Payroll                               1700 Washington

27 rows selected.
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

===========================================================================(DROP TABLE)УДАЛЕНИЕ ТАБЛИЦЫ=========================================================
4. Дропнуть таблицу DEPARTMENTS.

DROP TABLE HR.DEPARTMENTS CASCADE CONSTRAINTS; -- удаляет таблицу со всем содержимым, игнорируя ссылочную целостность (первичный ключи и т.д.)

====================================================================================================================================================================

5. Попробовать выполнить шаг 3 - полученную ошибку сохранить в нотку
ORA-04063: view "HR.DEP_LOC" has errors
SQL> show errors  --показать ошибку
====================================================================================================================================================================
6. проверить что в DBA_OBJECTS статус VIEW стал INVALID

OWNER      OBJECT_TYPE          OBJECT_NAME                    STATUS
---------- -------------------- ------------------------------ -------
HR         VIEW                 DEP_LOC                        INVALID
           VIEW                 EMP_DETAILS_VIEW               INVALID
====================================================================================================================================================================
7. попробовать скомпилировать VIEW - полуенную ошибку сохранить

SQL> EXEC UTL_RECOMP.recomp_parallel(4);

PL/SQL procedure successfully completed.
=====================================================================================================================================================================
ALTER VIEW DEP_LOC COMPILE;

SQL> ALTER VIEW DEP_LOC COMPILE;
ALTER VIEW DEP_LOC COMPILE
           *
ERROR at line 1:
ORA-00942: table or view does not exist

======================================================================================================================================================================
====================================================================DATA_PUMP import TABLE (импорт таблицы impdp)=====================================================
8. импортировать таблицу DEPARTMENTS обратно в схему HR

impdp SYSTEM/oracle TABLES=HR.DEPARTMENTS dumpfile=dpdumps:HR_13.42_17.12.2020.dmp logfile=dplogs:imp_TABLE.HR.DEPARTMENTS_$mydate.log REMAP_TABLESPACE=USERS:HR_TBS

======================================================================================================================================================================

==================================================================CRONTAB DATA PUMP export===============================================================================

# пишем скрипт который применяет перменное окружение и прогоняет экспорт : называем его например script_export.sh
	#!/bin/bash
	mydate=`date "+%H.%M_%d.%m.%Y"`  ##### задаем переменную в которую записываем текущее время для подстановки в имя файла
	source /home/oracle/valentin.env    #### применяем переменное окружение, данный файл содержит:
	ORACLE_HOME=/u01/app/oracle/product/12.2.0/dbhome_1;
	export ORACLE_HOME;
	PATH=$ORACLE_HOME/bin:$PATH
	export PATH;
	ORACLE_SID=valentin;
	export ORACLE_SID;
	expdp SYSTEM/oracle SCHEMAS=HR,BI,OE,PM,IX,SH DIRECTORY=dmpdir DUMPFILE=HR_BI_OE_PM_IX_SH_schemas_$mydate.dmp LOGFILE=HR_BI_OE_PM_IX_SH_schemas_$mydate.log
#В терминале прогоняем
	$crontab -e    #### откроется текстовый файл в котором указываем время запуска и сам скрипт
		59 18 * * * /home/oracle/crontab_expdp_SCHEMAS_HR_BI_OE_PM_IX_SH.sh &>> /u01/arch/cron_log/expdp_HR_BI_OE_PM_IX_SH_schemas_$mydate.log
			время выполняемый скрипт и перенаправляем стандартный поток вывода и вывода ошибок в файл

=====================================================Auto Start Oracle Database on Linux (автозапуск ДБ после перезагрузки)==========================================================
# при помощи любого текстового редактора открываем файл:
vi /etc/oratab которой содержит примерно следующее:
	$ORACLE_SID:$ORACLE_HOME:<N|Y>
		valentin:/u01/app/oracle/product/12.2.0/dbhome_1:Y    ###подставляем $ORACLE_SID:$ORACLE_HOME
# пересохидим в дирректорию:
	cd /etc/init.d
# далее при помощи текстового редактора создаем файл в дирректории /etc/init.d
	vi dbora    #### dbora имя файла
#!/bin/sh
ORACLE_HOME=/u01/app/oracle/product/11.2.0/dbhome_1
ORACLE_OWNER=oracle

case "$1" in
'start') # Start the Oracle databases and listeners
su - $ORACLE_OWNER -c "$ORACLE_HOME/bin/dbstart $ORACLE_HOME"
;;
'stop') # Stop the Oracle databases and listeners
su - $ORACLE_OWNER -c "$ORACLE_HOME/bin/dbshut $ORACLE_HOME"
;;
esac

#chgrp dba dbora   ### Меняем группу
#chmod 750 dbora   ### Задаем права

#Создаем ссылки
	ln -s /etc/init.d/dbora /etc/rc.d/rc0.d/K01dbora
	ln -s /etc/init.d/dbora /etc/rc.d/rc3.d/S99dbora
	ln -s /etc/init.d/dbora /etc/rc.d/rc5.d/S99dbora

==================================================================================================================================================================================
===============================================DROP DATABASE (УДАЛЕНИЕ БД)======================================================================================================

SQL> SHUTDOWN IMMEDIATE;
	SQL> startup mount exclusive restrict;
		SQL> drop database;

=================================================================================RMAN BACKUP INCREMENTAL LEVEL 0================================================================
rman target /

RUN {
    BACKUP INCREMENTAL LEVEL 0 DATABASE PLUS ARCHIVELOG TAG "LEVEL 0";
    BACKUP CURRENT CONTROLFILE SPFILE;
}

===========================================================================RMAN BACKUP INCREMENTAL LEVEL 1=========================================================================

rman target /

BACKUP INCREMENTAL LEVEL 1 DATABASE PLUS ARCHIVELOG TAG "LEVEL 1";




BACKUP INCREMENTAL LEVEL 1 DATABASE PLUS ARCHIVELOG TAG "LEVEL 1 no USERS";


============================================================================RMAN RESTORE/RECOVER DATABASE=====================================================================

#В терминале запускаем улититу RMAN и целевую БД
	rman target /
#SET DBID 1791515810
	#startup force nomount     ### dammy instance
		#RESTORE SPFILE FROM '/u01/app/oracle/fast_recovery_area/valentin/VALENTIN/autobackup/2020_12_22/o1_mf_s_1059837738_hy3s7tf6_.bkp'; указываем путь до файла бэкапа в котором содержится информаци о SPFILE
			#SHUTDOWN IMMEDIATE
				#startup nomount     #### restart instance with pfile
					#RESTORE CONTROLFILE FROM AUTOBACKUP;
						#alter database mount;
							#restore database;
								#recover database;
									#alter database open resetlogs; ###### БД восстанавливает до последнего SCN

# Если надо восстановться до пределенного  SCN
	#RESTORE CONTROLFILE FROM '/u01/app/oracle/fast_recovery_area/valentin/VALENTIN/autobackup/2020_12_22/o1_mf_s_1059837942_hy3sg75b_.bkp';  ### указываем файл бекапа который содержит подходящий SCN
		#restore database from TAG='TAG20201222T152107'   #### указываем TAG or SCN
			#reset database to incarnation 1;     ### при необходимости (выбираем с подходящим SCN)
				#recover database until scn 1717354;   ### указываем SCN
					#alter database open resetlogs;

##########################################################RMAN COMMAND

#вывести информацию о БЭКАПАХ
	LIST BACKUP OF DATABASE;
		list backup summary;
			LIST BACKUP
#выести информацию о Incarnations
	list incarnation of database;

# для добалвения времени в бэкапы при выводе LIST BACKUP
	$ NLS_DATE_FORMAT="yyyy-mm-dd:hh24:mi:ss"
		$ export NLS_DATE_FORMAT="yyyy-mm-dd:hh24:mi:ss"
			$ . .bash_profile
##########################################################################
==================================================================================================================================================================================

===========================================================================узнать время по номеру SCN============================================================================

SQL> select scn_to_timestamp(1718146) from dual;

=============================================================================вывести все схемы в БД==============================================================================

SQL> select USERNAME from dba_users;

=============================================================== BASH SCRIPT for SQL ( DATABASE )===================================================================================

#!/bin/bash
sqlplus / as sysdba << EOF
select * from HR.REGIONS;
EOF  

===================================================================================================================================================================================

=======================================================================================================================================================================================
0. удалить старые rman бекапы
1. подготовить RMAN command file , который будет  создавать rman бекап lvl0 с бекапом controlfile & spfile. Протестировать его на БД напрямую
2. Подготовить второй RMAN command file, который будет делать аналогичный lvl1 бекап + cf & spfile
3. Подготовить третий RMAN command file , который будет полный restore & recover с существующего бекапа RMAN

перед переходом к пункту 4 протестировать все вышеперечисленные rman command files вручную
——
4. Создать директорию /home/oracle/valentin , Сделать bash скрипт /home/oracle/valentin/valentin-ctl.sh с  библиотеками (bash library) в /home/oracle/valentin/lib, которые подключаются в основном скрипте и функции из которых будут вызывать в этом основном скрипте:
а) библиотека prepare-rman-command-file.lib должна содержать функцию , которая будет создавать rman command file в зависимости от переданного в неё аргумента. При поступлении аргумента lvl0 - будет создавать rman command file из пункта 1, при поступлении аргумента lvl1 - из пункта 2 и при поступлении аргумента restore - из пункта 3. Создаваемые rman command файлы должны находиться в /home/oracle/valentin/rman
б) библиотека запуска RMAN command file в RMAN. Должна содержать функцию,  аргументом которой будет сам rman command file . Функция должна запускать rman command file через RMAN

Основной скрипт - valentin-ctl.sh должен : подключать в себя эти библиотеки и использовать из них функции. Также должен принимать аргументы lvl0, lvl1, restore - на основе которых будут вызываться нужные функции

========================================================================Delete all backups for this database recorded in the RMAN repository===============================
0.
 DELETE BACKUP;

=================================================================== RMAN command file бекап lvl0 ============================================================================
1. подготовить RMAN command file , который будет  создавать rman бекап lvl0 с бекапом controlfile & spfile. Протестировать его на БД напрямую




================================================================================================
rman <<EOF
@rman_lvl0.rmn

@rman_lvl0.rmn
RUN {
    BACKUP INCREMENTAL LEVEL 0 DATABASE PLUS ARCHIVELOG TAG "LEVEL_0";
    BACKUP CURRENT CONTROLFILE SPFILE;
}
quit
EOF

=============================================================================================
rman <<EOF
connect target /
@rman_lvl1.rmn

@rman_lvl1.rmn
RUN {
BACKUP INCREMENTAL LEVEL 1 DATABASE PLUS ARCHIVELOG TAG "LEVEL 1";
BACKUP CURRENT CONTROLFILE SPFILE;
}
quit
EOF
============================================================================================

@rman_recovery
RUN {
SET DBID 1791515810;
startup force nomount
RESTORE SPFILE FROM '/u01/app/oracle/fast_recovery_area/valentin/VALENTIN/autobackup/2020_12_24/o1_mf_s_1060011936_hy93cjf2_.bkp';
SHUTDOWN IMMEDIATE
startup nomount
RESTORE CONTROLFILE FROM AUTOBACKUP;
alter database mount;
restore database;
recover database;
}
RUN {
alter database open resetlogs;
}
quit
EOF
==================================================================================================================================================





===========================================================blocking session================================================================================================

Узнать какая сессия какую блокирует:

вариант 1.

SELECT s1.username || '@' || s1.machine
    || ' ( SID=' || s1.sid || ' )  is blocking '
    || s2.username || '@' || s2.machine || ' ( SID=' || s2.sid || ' ) ' AS blocking_status
    FROM gv$lock l1, gv$session s1, gv$lock l2, gv$session s2
    WHERE s1.sid=l1.sid AND s2.sid=l2.sid
    AND l1.BLOCK=1 AND l2.request > 0
    AND l1.id1 = l2.id1
    AND l1.id2 = l2.id2;

Вариант 2.


SELECT
   s.blocking_session,
   s.sid,
   s.serial#,
   s.seconds_in_wait,
   s.INST_ID
FROM
   gv$session s
WHERE
   blocking_session IS NOT NULL;






Вариант 3.


select sid, blocking_session from V$session where blocking_session is not null;

РЕШЕНИЕ.

Завершение блокирующей сессии. kill session


 =======================================================================================================================================================================

                                                                           SQL
 ===========================================================================================
 =! или <> знак отнрицания (не равно)
 | или
 column - столбцы
 expression- выражения
 condition- условия

 # Операторы сравнения
 =
 >
 <
 >=
 <=
 BETWEEN
 IN
 IS NULL
 LIKE
 |	|
'_''%'

# Логические операторы

AND
OR
NOT
====================================================================================================================================================
escape указывает после какого симовола (в примере это симовл '\') символ будет не специальным, а обычным.

Select * from  enployees where  job_id like 'ST\_%' escape '\'

 ==================================================================================================================================================================================
####################################################################################Oreder by#########################################################################################

select *|{DISTINCT column(s) alias, expression alias} FROM table WHERE condition(s) ORDER BY {col(s)|expr(s)|numeric position} {ASC|DESC}{NULLS FIRST|LAST};

ASC сортировка по нарастающей (по умолчанию, явно можно не указывать)
DESC Сортировка по убывающей, от большего к меньшему

###################################################################################Function############################################################


                FUNCTION
				|	   |
        sigle-row     Multiple-row

# single-row

#############character function

s-строка, текст
n-конечная длина текста
p-текст для заполнения
trimstring-текс который надо срезать

##Функция LOWER(s) - делает все буквы в выводе прописные

select LOWER(first_name) from employees;
select * from employees where LOWER (first_name) = 'david';

##Функция UPPER(s) -делает все буквы большими

##Функция INITCAP(s)- каждую первую букву делает заглавной, а все отстальные прописными

##CONCAT(s,s) объединяет строки как и знак конкатенации ||
select CONCAT ('privet, ', 'drug') from dual;

##LENGTH(s) вычисляет длину строки
select first_name, LENGTH(first_name) as dlina from employees;

##TRIM({trailing|leading|both} trimstring from s) удаляет символ сначала, с конца или сначала и конца текста
Например
select TRIM('    Valentin   Romanov    ') from dual; Удалит пробелы с начала и конца текста, но посередине не удаляет.     
##LPAD(s,n,p) и RPAD(s,n,p) добавление текста влева или вправо

##REPLACE('s', 'search item', 'replacement item') -заменить текст в строке
s - строка
search item- что заменить
replacement item- на что заменить

#############Numeric function

## Round(n, precision) округление (по принципам математики)
n-число которое будем округлять
precision-точность

##TRUNC(n, precision) отрезает разряды (просто отсекает лишнее)
n-число которое будем округлять
precision-сколько символов обрезаем с конца

##########Date function

##SYSDATE - возвращает системную дату и время

##MOUNTHS_BETWEEN(start_date, end_date) выводит колличество месяцев между первой и второй датой
## ADD_MOUNTHS(date, number_of_months)

#######Conversion function
##TO_CHAR - функиция переводит число или дату в текст (VARCHAR2)
TO_CHAR(number,format mask,nls_parameters)
TO_CHAR(date,format mask,nls_parameters)
##TO_DATE - функция переводит текст в дату
##TO_NUMBER- переводит текст в число


#####GENERAL FUNCTION
##NVL проверяет значение на null
##
##

#####Conditional function
##DECODE
DECODE(expr, comp1, iftrue1,comp2,iftrue2,...,compN, iftrueN, iffalse)
##CASE
####SIMPE CASE
CASE expr
WHEN comp1 THEN iftrue1
WHEN comp2 THEN iftrue2
..........
WHEN compN THEN iftrueN
ELSE iffalse
END
############################
###SEARCHED CASE
CASE
WHEN comp1 THEN iftrue1
WHEN comp2 THEN iftrue2
..........
WHEN compN THEN iftrueN
ELSE iffalse
END


#############################GROUP BY

SELECT * |{DISTINCT column(s) alias, expression(s) alias, group_function(s)(col|expr alias),}
FROM table
WHERE condition(s)
RGOUP BY{col(s)|expr(s)}
ORDER BY {col(s)|expr(s)|numeric position}{ASC|DESC}{NULLS FIRST|LAST};

###################JOIN
#######################################################################################################################################################################################
#######################################################################################################################################################################################
#######################################################################################################################################################################################
#######################################################################################################################################################################################
#######################################################################################################################################################################################
#######################################################################################################################################################################################
#######################################################################################################################################################################################
#######################################################################################################################################################################################
#######################################################################################################################################################################################
#######################################################################################################################################################################################
#######################################################################################################################################################################################
#######################################################################################################################################################################################
=======================================================================================================================================================================================
=======================================================================================================================================================================================
=======================================================================================================================================================================================
============================================================================СИГМА======================================================================================================
============================================================================СИГМА======================================================================================================
============================================================================СИГМА======================================================================================================
============================================================================СИГМА======================================================================================================
=======================================================================================================================================================================================
=======================================================================================================================================================================================
=======================================================================================================================================================================================
#######################################################################################################################################################################################
#######################################################################################################################################################################################
#######################################################################################################################################################################################
#######################################################################################################################################################################################
############################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################
#######################################################################################################################################################################################
##############################################################################################################################################################################################################################################################################################################################################################################
#####ПАРОЛЬ ДЛЯ ROOT на тестах dbhnefk



############################################ DB: PROD (ebsfdb1.interrao.ru)  ##################################

# Тип заявки: Инцидент
DB: PROD (ebsfdb1.interrao.ru)
Описание заявки Average: Oracle: Session blocks are increasing

#########
SOLUTION#
#########

1. Подключаемся к снеду ebsfdb1.interrao.ru от имени root
2. Логинимся под пользователем oracle
	# su - oracle
3. Смотрим какая сессия какую блокирует
	$ sqlplus / as sysdba @f_lock_session.sql

4. если в Holding session, значение Idle больше 10 минут, завершаем Holding session путем выполнения скрипта указанного  в выводе


################################ЕБ. Блокировка пользователей в SSO на ПРОМ стенде.#################################

Тип заявки: Запрос на обслуживание
Сводка: Блокировка в системе единого биллинга
Описание заявки : Прошу направить запрос в Сигму на блокировку пользователя в системе Единого биллинга в связи с увольнением

KODAEV 	Коровина Дарья Евгеньевна

#########
SOLUTION#
#########

делаем согласно инструкции https://confluence.sigma-it.ru/pages/viewpage.action?pageId=390047212

#######################################DB: DBCCB (ebuled3-scan1.spb-dc.interrao.ru)##########################################

############ ЗАЯВКА НА ДОБАВЛЕНИЕ ДАТАФАЙЛА!! (ADD DATAFILE)

[DBCCB] CISCCB_BP used more than 80%

#Тип заявки: Инцидент
#Описание заявки:
	DB: DBCCB (ebuled3-scan1.spb-dc.interrao.ru)

	Average: [DBCCB] CISCCB_BP used more than 80%
	Problem started at 09:11:59 on 2021.02.08
	Latest value: 80 %

#########
SOLUTION#     ДОБАВЛЕНИЕ datafile
#########

Общая инструкция https://confluence.sigma-it.ru/pages/viewpage.action?pageId=304840748

Инструкция для ASM

#########
ШАГ 1####
#########

###Проверяем выполняется ли в данный момент бекап БД:

set lines 300
SELECT SID, SERIAL#, OPNAME, SOFAR,TOTALWORK,UNITS, ELAPSED_SECONDS,TIME_REMAINING, ROUND(SOFAR/TOTALWORK*100,2) "%_COMPLETE"
FROM V$SESSION_LONGOPS WHERE OPNAME LIKE 'RMAN%'  AND OPNAME NOT LIKE '%aggregate%'  AND TOTALWORK != 0  AND SOFAR != TOTALWORK;
Если "no rows selected"- продолжаем.

###Если сейчас активный бекап, то  нужно дождаться его завершения и затем продолжить.



###Проверяем где хранятся файлы данных на ASM или нет запросом ниже. Если файлы хранятся файловой системе ОС Линукс, то будет выведен путь в линуксе до файлов данных :

select distinct substr(name, 1, instr(name, '/', -1) - 1) from(select name from v$datafile);

SUBSTR(NAME,1,INSTR(NAME,'/',-1)-1)
--------------------------------------------------------------------------------
/u02/oradata/oradata/nsd4


###Если файлы на ASM то будет выведено имя диск группы и путь до файлов данных:

SQL> select distinct substr(name, 1, instr(name, '/', -1) - 1) from(select name from v$datafile);

SUBSTR(NAME,1,INSTR(NAME,'/',-1)-1)
------------------------------------------------------------------------------------------------------------------------------------------------------
+DATAC1/dbccb/datafile

###В случае ASM: Проверяем заполненность диск-группы используя следующий SQL-запрос:

set linesize 300
set pagesize 50
col GROUP_NUMBER format 99
col NAME format a15
col STATE format a15
col TYPE format a15
select GROUP_NUMBER,NAME,STATE,TYPE,ceil(TOTAL_MB/1024) "TOTAL_GB",ceil(FREE_MB/1024) "FREE_GB",100-(FREE_MB/TOTAL_MB)*100 "PERCENT USED" from V$ASM_DISKGROUP;


###Если на диске или в дисковой группе ASM очень мало места - добавлять надо с осторожностью, чтобы использование не стало 100% (лучше проконсультироваться со старшим инженером).

###В случае если использование диска или дисковой группы 100% - необходимо проэскалировать согласно порядку эскалации.


###Смотрим информацию о файлах данных в табличном пространстве на которое пришёл инцидент (на примере инцидента 236482 для табличного пространства CISADM_IDX )


set lines 300 pages 300
column FILE_NAME format a50
column MAXBYTES for 99999999999999999
select file_id,tablespace_name,FILE_NAME,BYTES/1024/1024,AUTOEXTENSIBLE,MAXBYTES from dba_data_files where TABLESPACE_NAME='CISCCB_BP';   -- Подставить имя табличного пространства


###Вывод содержит следующую информацию:


  FILE_ID TABLESPACE_NAME                FILE_NAME                                          BYTES/1024/1024 AUT           MAXBYTES
---------- ------------------------------ -------------------------------------------------- --------------- --- ------------------
        34 CISADM_IDX                     +DATAC1/dbccb/datafile/cisadm_idx.1724.968962487        32767,9844 YES        34359721984     ---- MAXBYTES  34359721984  байт = 32Гига
        36 CISADM_IDX                     +DATAC1/dbccb/datafile/cisadm_idx.1756.968962491        32767,9844 YES        34359721984
        40 CISADM_IDX                     +DATAC1/dbccb/datafile/cisadm_idx.823.968962495         32767,9844 YES        34359721984
        41 CISADM_IDX                     +DATAC1/dbccb/datafile/cisadm_idx.804.968962499         32767,9844 YES        34359721984

...
...
...


###Добавляем по подобию: файл данных в диск группе +DATAC1 , начальный размер выбираем 500Мегабайт  с включённым авто-расширением до максимального размера 32Гига на следующие с шагом по 100М:

ALTER TABLESPACE CISADM_IDX ADD DATAFILE '+DATAC1' SIZE 500M AUTOEXTEND ON NEXT 100M MAXSIZE 34359721984;

Пример в sqlplus:

SQL> ALTER TABLESPACE CISADM_IDX ADD DATAFILE '+DATAC1' SIZE 500M AUTOEXTEND ON NEXT 100M MAXSIZE 34359721984;

Tablespace altered.


### В случае если на ОС

# Смотрим информацию о файлах данных в табличном пространстве на которое пришёл инцидент

set lines 300 pages 300
column FILE_NAME format a50
column MAXBYTES for 99999999999999999
select file_id,tablespace_name,FILE_NAME,BYTES/1024/1024,AUTOEXTENSIBLE,MAXBYTES from dba_data_files where TABLESPACE_NAME='EC_TBS_KND'; -- Подставить имя табличного пространства

#  Смотрим заполненность

!df -h /u01/data/ecr/db/ecr/ec_tbs_knd06.dbf

# Добавляем ДАТАФАЙЛ на ОС

ALTER TABLESPACE EC_TBS_KND ADD DATAFILE '/u01/data/ecr/db/ecr/ec_tbs_knd07.dbf' SIZE 500M AUTOEXTEND ON NEXT 100M MAXSIZE unlimited;

#########
ШАГ 2####     ДОБАВЛЕНИЕ ДАТАФАЙЛА
#########
###============================== How to add datafile to ASM ================================================

ALTER TABLESPACE CISCCB_BP ADD DATAFILE '+DATA' SIZE 500M AUTOEXTEND ON NEXT 100M MAXSIZE unlimited;
//or this
ALTER TABLESPACE BI_STAGE ADD DATAFILE '+DATA' SIZE 16384M;


###Повторяем добавление файла данных, до тех пор пока использование не будет меньше порогового значения.

Проверить заполненность можно с помощью скрипта

select * from dba_tablespace_usage_metrics;

или

select 'Tablespace '''||m.TABLESPACE_NAME||''' is '||round(USED_PERCENT)||'% used and has '||(TABLESPACE_SIZE-USED_SPACE)*t.block_size/1024/1024||' Mb left.' from DBA_TABLESPACE_USAGE_METRICS m, DBA_TABLESPACES t where t.tablespace_name = m.tablespace_name and m.TABLESPACE_NAME not in (select tablespace_name from DBA_TABLESPACES where CONTENTS = 'UNDO') and m.TABLESPACE_NAME='ODI';   --подставить имя табличного пространства

ПРОВЕРИТЬ ЗАПОЛНЕННОСТЬ TABLESPACE (скрипт из заббикс)

SELECT * FROM (
 select (100 * (SUM(a.bytes) - (c.Free)) /
       (SUM(decode(b.maxextend, null, A.BYTES, b.maxextend * 8192)))) USED_PCT
  from dba_data_files a,
       sys.filext$ b,
       (SELECT d.tablespace_name, sum(nvl(c.bytes, 0)) Free
          FROM dba_tablespaces d, DBA_FREE_SPACE c
         WHERE d.tablespace_name = c.tablespace_name
           and d.tablespace_name = 'ODI'                    --------------- подставить имя табличного пространства
         group by d.tablespace_name) c
 WHERE a.file_id = b.file#(+)
   and a.tablespace_name = c.tablespace_name
 GROUP BY a.tablespace_name, c.Free
union all
 select 0 from dual
) WHERE ROWNUM = 1

###Проверяем, что в заббикс дешборде появилось сообщение RESOLVED, закрываем инцидент.



#=========================================================ЕИСЗ ИРАО. Установка обновлений (версий)=================================================================

Интрукция для ЕИСЗ https://confluence.sigma-it.ru/pages/viewpage.action?pageId=399345724

ЗАДАЧА

Описание: Прошу установить  версию на ИНТЕРРАО ТЕСТ  и ПРОД

								XXEXP_RPEO 3.0
								Рестарт oacore НЕ требуется.!!!


#########
SOLUTION#
#########

# 1. Подключаемся к стенду по SSH, авторизуемся по ключу (пользователь root). Далее, авторизуемся под пользователем oracle:

root@EBSFAPP1-TST1:~# su - oracle

# 2. В случае, когда необходима установка только одного пакета и при этом требуется перезапуск oacore, то в конце добавляем ключ Y и запускаем выполнение скрипта. Соответственно, если перезапуск oacore не требуется, выполняем скрипт без ключа Y.

Если в Задаче просят приложить логи установки, то добавляем команду tee /tmp/NSD<НОМЕР_ЗАДАЧИ>.log, она запишет процесс установки в файл .log, который потом будет необходимо приложить к Задаче.

oracle@EBSFAPP1-TST1:~$ ./wget_versions.sh XXPON03.003 2.6 Y | tee /tmp/NSD20396.log

# В случае, когда необходима установка нескольких пакетов, то устанавливаем их последовательно, при этом перезапускаем oacore (если требуется) только после установки последнего пакета (добавляем ключ Y при установке последнего пакета).


oracle@EBSFAPP1-TST1:~$ ./wget_versions.sh XXPON03.003 2.6  | tee /tmp/NSD20396.log
oracle@EBSFAPP1-TST1:~$ ./wget_versions.sh XXPON_EXPERT223 1.0 Y | tee -a /tmp/NSD20396.log

Если файлы на сервере уже существуют (при повторной установке пакета, например), появляется запрос о замене файлов, в этом случае отвечаем A (All).

Если при установке пакетов перезапуск oacore не был произведен, а по Задаче перезапуск требуется, то можно сделать это двумя способами:

a) Первый способ. Запускаем скрипт restart_oacore.sh, который расположен в домашнем каталоге пользователя oracle. В конце выводится статус процессов, который при корректном запуске, должен быть Alive.

oracle@EBSFAPP1-TST1:~$ ./restart_oacore.sh

b) Второй способ. Переходим в каталог $ADMIN_SCRIPTS_HOME, в котором размещен скрипт adoacorectl.sh

oracle@EBSFAPP1-TST1:~$ cd $ADMIN_SCRIPTS_HOME
oracle@EBSFAPP1-TST1:/u02/oracle/TST1/inst/apps/TST1_ebsfapp1-tst1/admin/scripts$

# остановка
oracle@EBSFAPP1-TST1:/u02/oracle/TST1/inst/apps/TST1_ebsfapp1-tst1/admin/scripts$ ./adoacorectl.sh stop
You are running adoacorectl.sh version 120.13
Stopping OPMN managed OACORE OC4J instance ...
adoacorectl.sh: exiting with status 0
adoacorectl.sh: check the logfile /u02/oracle/TST1/inst/apps/TST1_ebsfapp1-tst1/logs/appl/admin/log/adoacorectl.txt for more information ...

# запуск
oracle@EBSFAPP1-TST1:/u02/oracle/TST1/inst/apps/TST1_ebsfapp1-tst1/admin/scripts$ ./adoacorectl.sh start
You are running adoacorectl.sh version 120.13
Starting OPMN managed OACORE OC4J instance ...
adoacorectl.sh: exiting with status 0
adoacorectl.sh: check the logfile /u02/oracle/TST1/inst/apps/TST1_ebsfapp1-tst1/logs/appl/admin/log/adoacorectl.txt for more information ...

# статус (при корректном запуске, статус должен быть Alive)
oracle@EBSFAPP1-TST1:/u02/oracle/TST1/inst/apps/TST1_ebsfapp1-tst1/admin/scripts$ ./adoacorectl.sh status
You are running adoacorectl.sh version 120.13
Checking status of OPMN managed OACORE OC4J instance ...
Processes in Instance: TST1_ebsfapp1-tst1.ebsfapp1-tst1.interrao.ru
---------------------------------+--------------------+---------+---------
ias-component                    | process-type       |     pid | status
---------------------------------+--------------------+---------+---------
OC4JGroup:default_group          | OC4J:oafm          |   21788 | Alive
OC4JGroup:default_group          | OC4J:forms         |   21714 | Alive
OC4JGroup:default_group          | OC4J:oacore        |   23850 | Alive
OC4JGroup:default_group          | OC4J:oacore        |   23849 | Alive
HTTP_Server                      | HTTP_Server        |   21466 | Alive

adoacorectl.sh: exiting with status 0
adoacorectl.sh: check the logfile /u02/oracle/TST1/inst/apps/TST1_ebsfapp1-tst1/logs/appl/admin/log/adoacorectl.txt for more information ...

Если в процессе установки ПО возникают ошибки, сообщаем об этом разработчикам посредством Skype в группу Установка версий (либо любым другим способом) и ждем от них дальнейших инструкций.

# 3. Прикладываем логи установки к Задаче (если требовалось) и закрываем её.


#==================================================ccbpek2.sigma-it.local (ТЕСТ) (ЕБСРЮЛ) Average: Free disk space is less than 20% on volume=======================================


Тип заявки: Инцидент
Описание заявки:
ccbpek2.sigma-it.local

Average: Free disk space is less than 20% on volume /var
Problem started at 12:39:07 on 2021.02.09
Latest value: 11.25 %

Общая Инструкция https://confluence.sigma-it.ru/display/ORADBA/WARNING+Free+disk+space+is+less+than+on+volume

#########
SOLUTION#
#########
1. логинимся под root

2. Смотрим общую картиру и процентное соотношение забитости загруженного маунтпоинта (триггер срабатывает на 80 %)

# df -h

3. Заходим в проблемный маунтпоин, в данному случае в /var

# cd /var

4. Выполнить команду

# du -sh *

5. Самые большие дириктории буду внизу вывода, если это дирректории yum прогоняем команду

# yum clean all

6. Смотрим общую картиру и процентное соотношение забитости загруженного маунтпоинта (триггер срабатывает на 80 %)

df -h

если проблемный маунтпоинт забит меньше чем на 80%, задача выполнена


#=======================================================ias-db.fast.pesc.ru Остановка и запуск джобы (JOBS)================================================================
Стандартная задача "43328"

Описание: 1. Прошу отключить автоматическое обновление отчетности ИАС по ПЭС :
		  Джоб: BI_SA_FL.LOAD_SA_DWH_JOB_PES

		  Стенд: (DESCRIPTION = (ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = eias-db.fast.pesc.ru)(PORT = 1521))) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = DWHPRD)))

          2. Прошу включить автоматическое обновление отчетности ИАС ПЭС+ПСК с 11/02/2021 в 02:00 по мск времени:

          Джоб: BI_SA_FL.LOAD_SA_DWH_JOB

          Стенд: (DESCRIPTION = (ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = eias-db.fast.pesc.ru)(PORT = 1521))) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = DWHPRD)))


#########
SOLUTION#
#########

#I. остановка выполнения по расписанию

1. Подключаемся к БД через ТОАД либо как sys либо под владельцем джобы (в данном примере владельцем является BI_SA_FL)

2. В тоад выбираем меню schema browser и там выбираем необходиму схему (в данном примере BI_SA_FL) и Sched.JOBS и ищем необходимую джобу (в данном примере LOAD_SA_DWH_JOB_PES)

3. Првоверяем не выполняется ли в настоящее время джоба которую надо остановить

select * from dba_scheduler_running_jobs;

если в выводе нет нужной джобы то переходим к п. 4., если джоба бежит, то ждем ее завершения. Прерывать выполнение, только по согласласованию.

4. жмякаем правой кнопкой по джобе и выбираем disabled Selected jobs


#II. запуск (включение выполнения) джобы по расписанию

1. В тоад выбираем меню schema browser и там выбираем необходиму схему (в данном примере BI_SA_FL) и Sched.JOBS и ищем необходимую джобу (в данном примере LOAD_SA_DWH_JOB)

2. Проверяем системное время и проверяем его с расписание

select sysdate from dual;

если время на сервере по МСК и время по задачи по МСК то все ОК

3. жмякаем правой кнопкой по джобе и выбираем Enable Selected jobs


#==========================================The ARCHIVELOG done more than 4h=============================================

Тип заявки: Инцидент

Average: The ARCHIVELOG done more than 4h
Problem started at 12:00:11 on 2021.02.11
Latest value: 04:09:55

#ПРОСМОТРЕТЬ BACKUP (БЭКАПЫ)

alter session set nls_date_format='mm-dd-yyyy hh24:mi:ss';

-- в данный момент
set lines 300
SELECT SID, SERIAL#, OPNAME, SOFAR,TOTALWORK,UNITS, ELAPSED_SECONDS,TIME_REMAINING, ROUND(SOFAR/TOTALWORK*100,2) "%_COMPLETE"
FROM GV$SESSION_LONGOPS WHERE OPNAME LIKE 'RMAN%'  AND OPNAME NOT LIKE '%aggregate%'  AND TOTALWORK != 0  AND SOFAR != TOTALWORK;

-- all backups
select status, start_time,end_time, object_type Объект, floor(input_bytes / 1024 / 1024 / 1024) input_GB, floor(output_bytes  / 1024 / 1024 / 1024) output_GB  from gv$rman_status where start_time > SYSDATE -30 and operation = 'BACKUP' order by start_time desc

-- only DB INCR
select status, start_time,end_time, object_type Объект, floor(input_bytes / 1024 / 1024 / 1024) input_GB, floor(output_bytes  / 1024 / 1024 / 1024) output_GB  from gv$rman_status where start_time > SYSDATE -30 and operation = 'BACKUP' and object_type = 'DB INCR' order by start_time desc

-- текущий бэкап снизу
set lines 220
col output_bytes_display for a30
col time_taken_display for a30
select session_key,input_type,status,
     to_char(start_time,'yyyy-mm-dd hh24:mi') start_time,
       to_char(end_time,'yyyy-mm-dd hh24:mi') end_time,
       output_bytes_display,       time_taken_display
from v$rman_backup_job_details
where END_TIME > sysdate-30 --and input_type='DB FULL'
order by session_key asc;

#===========================================Create DDL for package===================================================

Скирипт используется для (бэкапа) BACKUP пакетов

--Create DDL for package

set long 100000
set head off
set echo off
set pagesize 0
set verify off
set feedback off
select dbms_metadata.get_ddl('PACKAGE_SPEC', 'CM_TMB_PRIL', 'CISADM') from dual;
select dbms_metadata.get_ddl('PACKAGE_BODY', 'CM_TMB_PRIL', 'CISADM') from dual;

--CISADM -имя схемы
--CM_BI_RECONCILIATION имя пакета

#===========================================================Компиляция пакетов=================================================================
ПОДРОБНАЯ ИНСТРУКЦИЯ
https://confluence.sigma-it.ru/pages/viewpage.action?pageId=399348676

#============================================================Проверить валидность пакета========================================================

select object_name, owner, object_type, status, created,last_ddl_time from dba_objects where owner='CISADM' and object_name ='CM_TMB_PRIL';

--CISADM -имя схемы
--CM_TMB_PRIL имя пакета
======================================================================

#=================================================================УСТАНОВКА ВЕРСИЙ  ИСУСЭ БП УЭС http://ues-istest1.corp.uralsbyt.ru:8080/WebPortal)====================================
Тип заявки: Запрос на изменение

На НСУБД
Внешний тестовый стенд ИСУСЭ БП УЭС.
http://ues-istest1.corp.uralsbyt.ru:8080/WebPortal
Прошу на внешний тестовый стенд ИСУСЭ БП УЭС установить версию 30.0.28 .
Расположение версии:
http://tc.sigma-it.local:8080/nexus/service/local/repositories/snapshots/content/ru/sigma-it/isuse-omsk/assembly/30.0.28-SNAPSHOT/assembly-30.0.28-20210212.095039-3.tar.gz

Прошу обратить внимание, установка версии должна производиться в схему TIGER

#########
SOLUTION#
#########
Инструкция https://confluence.sigma-it.ru/pages/viewpage.action?pageId=205684741

1. Скачиваем архив к себе на компьютер

2. В системе мониторинга Zabbix в меню Configuration ==> Maintenance выбираем нужный хост, далее переходил на вкладку  periods ==> add, добавляем примреное время проводимых работ. жмем применить.

Далее ВСЕ ДЕЙСТВИЯ ДЕЛАЕМ от имени root

4. Заходим на удаленный хост в каталог /u01, где находится tomcat, который необходимо отключить

# cd /u01/

5. В каталоге может находиться tomcat8 и tomcat8-rest. Если есть оба отключаем оба, если только tomcat8, отключаем только его

# service tomcat8 stop

# service tomcat8-rest stop

6. Заходим на удаленный хост в каталоге tmp
# cd /tmp/

7. В каталоге tmp создаем папку с именем NSD_номер заявки и переходим в нее

# mkdir NSD_508969

# cd /NSD_508969

8. При помощи утилиты WINscp заходим на удаленный хост и копируем в ранее созданную папку (NSD_508969) скаченный ранее архив.
		Так же можно копировать при помощи утилиты wget (скачивает в текущую папку)
			Например:
# wget http://tc.sigma-it.local:8080/nexus/service/local/repositories/snapshots/content/ru/sigma-it/isuse-omsk/assembly/30.0.28-SNAPSHOT/assembly-30.0.28-20210212.095039-3.tar.gz

9. Заходим на удаленный хост и проверяем что архив скачался
# ls -l

10. Распаковываю архив
# tar -xzvf assembly-30.0.28-20210212.095039-3.tar.gz

Архив должен содержать примрено следующее

assembly-30.0.28-20210212.095039-3.tar.gz
db.tar.gz
reports.tar.gz
WebPortal.war


11. Далее распаковываем архим db.tar.gz

# tar -xzvf db.tar.gz

В данном архиве содержится необходимый нам далее скрипт update.sh

12. Переходим в каталог db-30.0.28 (которая находилась в архиве db.tar.gz)
# cd db-30.0.28

13. Далее необходимо прогнать скрипт ./update.sh TIGER tigeruistest1 | tee -a ./db.log
	где
		TIGER это имя схемы
		tigeruistest1 пароль
			Что бы не искать пароль можно попробовать достать его из ранее выполненненного скрипта
				# history | grep update
ВАЖНО!!!!!!В выводе главное что бы знаечение Before было больше (>) After!!!!!! если значение  Before меньше After, узнаем о дальнейших действиях у заказчика скрипта.

если скрип бежит долго можно проверить нет ли блокировок

#Проверить блокировки

select
   blocking_session,
   sid,
   serial#,
   wait_class,
   seconds_in_wait
from
   gv$session
where
   blocking_session is not NULL
order by
   blocking_session;



14. Далее заходим в папку webapps/

# cd /u01/tomcat8/webapps

15. В каталоге /u01/tomcat8/webapps нас интерисует варка WebPortal.war. Нам необходимо сделать его резервную копию, на случай если что то пойдет не так

# mv WebPortal.war WebPortal.war.NSD_508969

16. Далее находясь в папке webapps необходимо удалить старую варку WebPortal.war и временные файлы

# rm -rf WebPortal ../work/Catalina/localhost/

17. Теперь необходимо из ранее распакованного архива переместить новую варку, находясь в папке webapps

# mv /tmp/NSD_508969/WebPortal.war ./

18. Меняем владельца и группу варки

# chown oracle:oinstall WebPortal.war

19. Запускаем tomcat

# service tomcat8 start

# service tomcat8-rest start

20. Проверяем доступность URL

21. В Заббикс снимаем Maintenance

Но это блять еще не все

22. Ищем путь к папке Reports

# locate Reports


вывод примерно

/u01/sgm/wls11/XMLP/Reports_/Юридические лица/Альтернатива/Форма №46-ЭЭ/REPORT_01_TEMPL_02.rtf
/u01/sgm/wls11/XMLP/Reports_/Юридические лица/Альтернатива/Форма №46-ЭЭ/Форма №46-ЭЭ.xdo
/u01/sgm/wls11/XMLP/Reports_/Юридические лица/Альтернатива/Форма №46-ЭЭ/Форма46.rtf


22. переходим в директорию

# cd /u01/sgm/wls11/XMLP/

23. Архивируем папку Reports (создаем архив с именем Reports.номер_заявки.tar.gz

# tar -czvf Reports.NSD508969.tar.gz Reports

24. Удаляем ранее папку  Reports и если есть старые архивы

# rm -rf Reports reports.tar.gz

25. Перемещаем в текущую директорию XMLP ранее скачанный архив ( в п.8)

# mv /tmp/NSD_508969/reports.tar.gz ./


26. Распокавываем архив

# tar -xzvf reports.tar.gz


27. Меняем владельца и группу для каталога Reports

# chown -R fusion:oinstall Reports


#=====================================================================================================================================================

Узнать пароль TIGER

[root@issigtest5app-vmw ~]# cd /u01/tomcat8/conf/WebPortal/
[root@issigtest5app-vmw WebPortal]# vi config.properties
[root@issigtest5app-vmw WebPortal]#

#=================================================================================================================================================


#=============================================================Групповой расчет УЭС==============================================================
######ЗАДАЧА!!
Групповой расчет УЭС 16.02.2021 в 15-00 по мск
на тестовом. стендеissigtest5app-vmw.sigma-it.local/WebPortal под схемой TIGER

Выполнить в следующем порядке:

1.Выполнить скрипт:

1) скрипт по добавлению общежитий

https://gitlab.sigma-it.ru/support/isuse-ues/-/blob/master/db/%D0%A1%D0%A3%D0%91%D0%94/ISUSE_UES2-322_load_TMP_HOSTEL_ABON.sql

2. После выполнения скрипта запустить групповой расчет на УЭС

Запуск расчёта скриптом

https://gitlab.sigma-it.ru/support/isuse-ues/-/blob/master/db/%D0%A1%D0%A3%D0%91%D0%94/UES_CREATE_MAIN_JOB_GROUP_58.SQL

Окончание расчёта фиксируется аналогично расчётам ОЭК.


##########
 #SOLUTION#
##########

(DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = issigtest5-vmw.sigma-it.local)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SERVICE_NAME = sigma)))

tiger/tiger

##################
нотка https://confluence.sigma-it.ru/pages/viewpage.action?pageId=292290608

1. Расчет необходимо мониторить каждый 15 минут


#==============================================================================узнать на каком порту слушает Listener в БД==============================================

SQL> select type, value from v$listener_network where type like '%LISTENER';

#=======================================================Узнать на каком хосту находится БД (хотснейм (hostname)======================================================================

SQL> select host_name from gv$instance

#========================================================================уникальны ошибки ORA=========================================================================

grep "ORA-" import_DBCCB_CISADM.log | sort -u > ORA-uniq_values.txt


#====================================================================show parameter undo========================================================================================

SQL> show parameter undo

#===================================================выводит колличество сессий с машины ( на загруженном сервере)===================================================================

Processes more than 85%

SQL> select count(machine) as count_machine, machine, INST_ID from gv$session group by machine,INST_ID;

#===========================================================show current SYSDATE=========================================================================
 Текущее время БД

SQL> SELECT TO_CHAR
    (SYSDATE, 'MM-DD-YYYY HH24:MI:SS') "NOW"
     FROM DUAL;

#===========================================================get password for specified user ISUSE=============================================================
=====
Вытащить пароль пользователя из БД
=====
ПАРОЛЬ ВЕБМОРДА ИСУСЭ под схемой TIGER
==================================
set serveroutput on
declare
    v_user_passw adms_vuser.user_password%TYPE;
begin
  for lst in (select upper(x.user_code) user_code,v.user_name,v.user_password
              from adms_vuser v,adms_xuser x
              where   v.user_id=x.user_id
                and v.arc_id=0 and upper(x.user_code) like '%ADM%') ---правило для поиска польз
                loop
                begin
    v_user_passw:=replace(dbms_obfuscation_toolkit.DES3Decrypt(input_string=>lst.user_password, key_string=>'rctybz1234567890'),'-');
    exception
     when others then v_user_passw:='';
     end;
    dbms_output.put_line(lst.user_code||'|'||lst.user_name||'|'||v_user_passw);
  end loop;
end;

#===============================================================ИСУСЭ БП. Обновление данных отчетности ИАС ( МОНИТОРИНГ)====================================================

-- Отслеживаем ход выполнения
select * from BI_SA_FL.sa_load_log          -- подставить схему
where START_DATE>=sysdate-2 order by START_DATE desc;

-- Отслеживаем операции выполняемые в текущий момент
select * from BI_SA_FL.sa_load_log_detail where START_DATE>=sysdate-1 and END_DATE is null order by START_DATE desc;

-- Проверяем длительность выполнения операции с предыдущими запускми (на данном примере шаг etl_person), если время существенно больше чем в предыдущие старты, есть вариант что процесс обновления "завис".
select * from BI_SA_FL.sa_load_log_detail where LOG_TEXT like 'etl_person' order by START_DATE desc;

-- Длительность "бегущего" процесса, с историей запусков
select ld.*, CASE WHEN ld.END_DATE is not null THEN trunc(24*mod(ld.END_DATE-ld.START_DATE,1)) || ' ч. ' || trunc( mod(mod(ld.end_date - ld.start_date,1)*24,1)*60 ) || ' м. '
||round(mod(mod(mod(ld.end_date - ld.start_date,1)*24,1)*60,1)*60,2) || ' сек '
ELSE    trunc(24*mod(sysdate-ld.START_DATE,1)) || ' ч. ' || trunc( mod(mod(sysdate - ld.start_date,1)*24,1)*60 ) || ' м. ' ||round(mod(mod(mod(sysdate - ld.start_date,1)*24,1)*60,1)*60,2) || ' сек '
  END EXEC_TIME  from BI_SA_FL.sa_load_log_detail ld
where LOG_TEXT in (select LOG_TEXT from BI_SA_FL.sa_load_log_detail where START_DATE>=sysdate-1 and END_DATE is null)
order by START_DATE desc;

#====================================================================monitor my RMAN errror logs and RMAN output? ================================================================

просмотреть логи RMAN онлайн в БД

SQL> select * from v$rman_output;

#===================================================================блокировка пользователя (блокирвока сессии)======================================================================

--показать блокирующую сессию

select gs.sid, gs.inst_id, gs.username, gs.client_identifier, subquery1.blks_sid, subquery1.blks_inst_id, subquery1.blks_username, subquery1.blks_client_identifier
   from gv$session gs
   INNER JOIN
   (select sid blks_sid, inst_id blks_inst_id, username blks_username, client_identifier blks_client_identifier from gv$session where sid in (select blocking_session from gv$session) and inst_id in (select BLOCKING_INSTANCE from gv$session)) subquery1
   on gs.blocking_session = subquery1.blks_sid and gs.BLOCKING_INSTANCE = subquery1.blks_inst_id

--показать какая сессия какую лочит

SELECT
CASE gl.request
    WHEN 0 THEN 'Holder'
    ELSE  LPAD(' ', 2, ' ' ) || 'Waiter'
END WHO,
gl.sid, gl.inst_id, gl.type, gs.username,gs.client_identifier,gs.module,gs.action
FROM gv$lock gl join gv$session gs on gl.sid = gs.sid and gl.inst_id = gs.inst_id
WHERE (gl.id1, gl.id2, gl.type) IN (
  SELECT id1, id2, type FROM gv$lock WHERE request>0)
ORDER BY gl.id1, gl.request;

#============================================================================Узнать размер схемы===================================================================================
Размер схемы

SELECT owner,
         tablespace_name,
         TO_CHAR (SUM (bytes) / 1024 / 1024 / 1024, '999,999.99') AS "Gb"
   FROM dba_segments
   WHERE tablespace_name IN (SELECT tablespace_name
                               FROM dba_tablespaces
                              WHERE tablespace_name LIKE 'TIGER%')    -- подставляем имя схемы
GROUP BY owner, tablespace_name
ORDER BY 1, 2;

#=====================================================UNLOCK ACCOUNT====================================================================================
ORA-28000: The account is locked.
--разблокировка пользователя с выдачей нового пароля и заменой пароля при первом входе
ALTER USER username IDENTIFIED BY password ACCOUNT UNLOCK PASSWORD EXPIRE;

#=======================================================просмотреть активные (бегущие) джобы================================================================================================

select * from dba_scheduler_running_jobs;

#=======================================================================узнать статус УЗ===============================================================================

select * from dba_users where account_status not like '%OPEN' and username like 'SIGSSHERMETOV'; --вводим имя пользователя и статус

select * from dba_users where username like 'SIGSSHERMETOV'; --указываем пользователя (выводит всю информацию по аккаунту пользователя)
