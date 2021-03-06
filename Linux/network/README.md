# Сетевые настройки

## Конфигурация сетевого интерфейса хранится в /etc/sysconfig/network-scripts в соответствующем файле с префиксом ifcfg

#### для просмотра сетевых инферфейсов можно воспользоваться следующей командной :
```

$ ip a
```
#### Для настройки сетевого интерфейса (адаптера) необходимо открыть любым тектовым редактором и отредактировать конфигурационный файл с соответствующим именем интерфейса :
```

$ sudo vi /etc/sysconfig/network-scripts/ifcfg-enp0s3

В данном конфигурационном файле прописываются сетевые настройки для адаптера интерфейса (например, ifcfg-enp0s3) :

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
NM_CONTROLLED="YES"				        # Указываем, должен ли интерфейс управляться с помощью NetworkManager и сохраняем изменения и закрываем
```

#### Чтобы настройки применились, перезапускаем сетевую службу:
```

# systemctl restart network
```

#### Редактируем основной сетевой конфигурационный файл /etc/sysconfig/network
```

vi /etc/sysconfig/network

файл содержит примерно следующее:

NETWORKING=YES
GATEWAY=192.168.1.1

Сетевое имя хоста прописывается в HOSTNAME, шлюз по умолчанию – в GATEWAY.
```

#### Настройка Параметров DNS:

Откройте файл /etc/resolv.conf

```
# vi /etc/resolv.conf

и прописываем в нем DNS сервера:

nameserver 192.168.1.2    # либо любой иной (4.4.4.4)

search                    # Список для поиска имен машин. Используется для resolva имен по короткому имени. (необязательно)

Сохраняем и закрываем файл.
```

#### Включить или выключить сетевой интерфейс:
```

ifdown ifcfg-enp0s3 И ifup ifcfg-enp0s3
```
