1. На машине ISP настраиваем адреса в нужные сети, прописывем трансляцию портов, разрешаем пересылку пакетов.

nano /etc/net/sysctl.conf

    net.ipv4.ip_forward = 1

iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE (так в нашем случае на вирт боксе! В других случаях проверяем интерфейс на ISP, который смотрит в интернет и его указываем, на HQ-RTR, BR-RTR интерфейс в сторону ISP )

2. Скрипты для автоматизации работы с HQ-RTR и BR-RTR.
Перед использованием скриптов на роутерах должны быть назначены адреса в сторону ISP, шлюз по умолчанию и в файле по адресу /etc/net/ifaces/enp0s3/resolv.conf добавлена строка nameserver 77.88.8.8
После исполнения скриптов HQ-RTR, BR-RTR поднимется туннель и ssh, натсроится динамическая маршрутизация.

 3. На машине HQ-SRV назначьте адрес из влана 100, настройте шлюз по умолчанию (192.168.100.2/28, шлюз 192.168.100.1, в файле по адресу /etc/net/ifaces/enp0s3/resolv.conf добавлена строка nameserver 77.88.8.8 )
    Запустите скрипт произойдет настройка ДНС и RAID.
 4. Службу времени настраиваем в ручную. 
    В ISP находим и удаляем строку pool в самом низу, затем добавляем:

nano /etc/chrony.conf

    local stratum 5
    allow 0/0

nano /etc/hosts

    192.168.0.1 br-rtr.au-team.irpo

systemctl restart chronyd

Для всех остальных:
nano /etc/chrony.conf

    Находим и меняем pool на pool 172.16.1.1 iburst (указываем адрес ISP)

systemctl restart chronyd


  5. Произведем настройку HQ-CLI. При включении машина должна получить адрес динамически от HQ-RTR.
  Запускаем скрипт HQ-CLI.sh и монтируем RAID
  6. На машине BR-SRV назначьте адрес, настройте шлюз по умолчанию (192.168.0.2/28, шлюз 192.168.0.1, в файле по адресу /etc/net/ifaces/enp0s3/resolv.conf добавлена строка nameserver 77.88.8.8 )
  скачайте скрипт и после создания скриптом юзера настройте ансибл. Файл inventory.yml скачается автоматом.
  nano inventory.yml

    Меняем адрес клиента на свой

nano ansibe.cfg

    interpreter_python = /usr/bin/python3
    inventory = /etc/ansible/inventory.yml
    host_key_checking = false

ansible -m ping all
