#/bin/bash
#  ---------    Запуск скрипта  -   ./check N_виртуальной машины_ISP  ----------
#  ----------------------   ./check 4011   ----------------------------------------
#  ---------    N_виртуальной машины_ISP  передается в качестве переменной  $1 ----
#  ISP     - 4011   0  0
#  HQ-RTR  - 4012   +1  1
#  BR-RTR  - 4013   +2  4
#  HQ-SRV  - 4014   +3  2
#  HQ-CLI  - 4015   +4  3
#  BR-SRV  - 4016   +5  5
# variable
std=$1; inet="8.8.8.8"; jq="(jq -r '."out-data"')"
#  настройка цвета шрифтов
c_black=$'\e[0;30m'   ; c_lblack=$'\e[1;30m'; 
c_red=$'\e[0;31m'     ; c_lred=$'\e[1;31m';
c_green=$'\e[0;32m'   ; c_lgreen=$'\e[1;32m';
c_yellow=$'\e[0;33m'  ;c_lyellow=$'\e[1;33m';
c_blue=$'\e[0;34m'    ; c_lblue=$'\e[1;34m';
c_purple=$'\e[0;35m'  ; c_lpurple=$'\e[1;35m';
c_cyan=$'\e[0;36m'    ; c_lcyan=$'\e[1;36m';
c_gray=$'\e[0;37m'    ; c_white=$'\e[1;37m';
c_null=$'\e[m'
c_value=${c_lblue}    ; c_error=${c_lred};
c_warning=${c_lyellow}; c_info=${c_lcyan} ;
c_ok=${c_lgreen} 

#hqsrv=$(qm guest exec $((std+3)) ip \-- -br a | jq -r '."out-data"' | grep enp7s1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
#brsrv=$(qm guest exec $((std+5)) ip \-- -br a | jq -r '."out-data"' | grep enp7s1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
#hqcli=$(qm guest exec $((std+4)) ip \-- -br a | jq -r '."out-data"' | grep enp7s1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
# | iconv -f utf-8 -t latin1   конвертация из linux в windows

function pressEnter {
  echo "$c_lred                             Нажмите клавишу Enter $c_null";
  read -s -n 1;  echo;
}

function tire {
  echo;
  echo "$c_lpurple ======================================================================================================================= $c_null";
  echo;
}

function heads {
  clear
  echo;
  echo "$c_lred ------------ Автоматизированная  проверка стенда Демонстрационного экзамена --------------$c_null";
  echo -e "$c_lred                              стенд $std - $((std+5))   $c_null \n";
}


function m1 {
# Модуль 1
echo -e "$c_error                                     МОДУЛЬ 1 $c_null \n\n";

# 1.1 --- Базовая настройка устройств
# --- Имена устройств
tire;
echo "$c_info 1.1 --------------------- Базовая настройка устройств --------------------------------------------$c_null";
  echo "$c_lgreen --- Имена узлов $c_null";
  echo -n "Имя узла ISP     =   ";   qm guest exec $std cat /etc/hostname | jq -r '."out-data"';
  echo -n "Имя узла HQ-RTR  =   ";   qm guest exec $((std+1)) cat /etc/hostname | jq -r '."out-data"';
  echo -n "Имя узла BR-RTR  =   ";   qm guest exec $((std+4)) cat /etc/hostname | jq -r '."out-data"';
  echo -n "Имя узла HQ-SRV  =   ";   qm guest exec $((std+2)) cat /etc/hostname | jq -r '."out-data"';
  echo -n "Имя узла HQ-CLI  =   ";   qm guest exec $((std+3)) cat /etc/hostname | jq -r '."out-data"';
  echo -n "Имя узла BR-SRV  =   ";   qm guest exec $((std+5)) cat /etc/hostname | jq -r '."out-data"';
  echo;

# --- IP address
  echo "$c_lgreen --- IP-адресация ISP $c_null";
  #qm guest exec $std ip \-- -br -c a | jq -r '."out-data"' | grep -v lo;
  isp_18=$(qm guest exec $std ip \-- -br a | jq -r '."out-data"' | grep enp7s1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
  isp_19=$(qm guest exec $std ip \-- -br a | jq -r '."out-data"' | grep enp7s2 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
  isp_20=$(qm guest exec $std ip \-- -br a | jq -r '."out-data"' | grep enp7s3 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
  echo "enp7s1 = " $isp_18;     echo "enp7s2 = " $isp_19;   echo "enp7s3 = " $isp_20;
  echo; 
  echo "$c_lgreen --- IP-адресация HQ-RTR $c_null";
  #qm guest exec $((std+1)) ip \-- -br -c a | jq -r '."out-data"' | grep -v lo;
  hqr_18=$(qm guest exec $((std+1)) ip \-- -br a | jq -r '."out-data"' | grep enp7s1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
  hqr_191=$(qm guest exec $((std+1)) ip \-- -br a | jq -r '."out-data"' | grep 100 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
  hqr_192=$(qm guest exec $((std+1)) ip \-- -br a | jq -r '."out-data"' | grep 200 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
  hqr_193=$(qm guest exec $((std+1)) ip \-- -br a | jq -r '."out-data"' | grep 999 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
  hqr_tu=$(qm guest exec $((std+1)) ip \-- -br a | jq -r '."out-data"' | grep tun | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
  if [ -z $hqr_tu ];
  then
    hqr_tu=$(qm guest exec $((std+1)) ip \-- -br a | jq -r '."out-data"' | grep gre | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
  fi
  echo "enp7s1 = " $hqr_18;  echo "enp7s2.100 = " $hqr_191;  echo "enp7s2.200 = " $hqr_192;  echo "enp7s.999 = " $hqr_193;
  echo "tunnel = " $hqr_tu;
  echo "$c_lgreen --- IP-адресация BR-RTR $c_null";
  #qm guest exec $((std+4)) ip \-- -br -c a | jq -r '."out-data"' | grep -v lo;
  brr_18=$(qm guest exec $((std+4)) ip \-- -br a | jq -r '."out-data"' | grep enp7s1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
  brr_19=$(qm guest exec $((std+4)) ip \-- -br a | jq -r '."out-data"' | grep enp7s2 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
  brr_tu=$(qm guest exec $((std+4)) ip \-- -br a | jq -r '."out-data"' | grep tun | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
  if [ -z $brr_tu ];
  then
    brr_tu=$(qm guest exec $((std+4)) ip \-- -br a | jq -r '."out-data"' | grep gre | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
  fi
  echo "enp7s1 = " $brr_18; echo "enp7s2 = " $brr_19; echo "tunnel = " $brr_tu;
  echo "$c_lgreen --- IP-адресация HQ-SRV $c_null";
  #qm guest exec $((std+2)) ip \-- -br -c a | jq -r '."out-data"' | grep -v lo;
  hqsrv=$(qm guest exec $((std+2)) ip \-- -br a | jq -r '."out-data"' | grep enp7s1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
  echo "enp7s1 = " $hqsrv;
  echo "$c_lgreen --- IP-адресация HQ-CLI $c_null";
  #qm guest exec $((std+3)) ip \-- -br -c a | jq -r '."out-data"' | grep -v lo;
  hqcli=$(qm guest exec $((std+3)) ip \-- -br a | jq -r '."out-data"' | grep enp7s1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
  echo "enp7s1 = " $hqcli;
  echo "$c_lgreen --- IP-адресация BR-SRV $c_null";
  #qm guest exec $((std+5)) ip \-- -br -c a | jq -r '."out-data"' | grep -v lo;
  brsrv=$(qm guest exec $((std+5)) ip \-- -br a | jq -r '."out-data"' | grep enp7s1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
  echo "enp7s1 = " $brsrv;
  echo;
#pressEnter;

# 1.2 --- ISP настройка
tire;
echo "$c_info 1.2 ------------ Проверка настройки ISP и маршрутизации  --------------$c_null";
  #dns_isp=$(qm guest exec $std cat /etc/hostname | jq -r '."out-data"');
  echo -n  "$c_lgreen --- Маршрутизация на ISP net.ipv4.ip_forward = $c_null";
  qm guest exec $std cat /proc/sys/net/ipv4/ip_forward | jq -r '."out-data"';
  echo "$c_lgreen --- Маршруты ISP $c_null";
  qm guest exec $std ip \-- -br -c r | jq -r '."out-data"' | grep -v lo;
echo;
  #dns_hqrtr=$(qm guest exec $((std+1)) cat /etc/hostname | jq -r '."out-data"');
  echo -n  "$c_lgreen --- Маршрутизация на HQ-RTR net.ipv4.ip_forward = $c_null";
  qm guest exec $((std+1)) cat /proc/sys/net/ipv4/ip_forward | jq -r '."out-data"';
  echo "$c_lgreen --- Маршруты HQ-RTR $c_null";
  qm guest exec $((std+1)) ip \-- -br -c r | jq -r '."out-data"' | grep -v lo;
echo;
  #dns_brrtr=$(qm guest exec $((std+2)) cat /etc/hostname | jq -r '."out-data"');
  echo -n  "$c_lgreen --- Маршрутизация на BR-RTR net.ipv4.ip_forward = $c_null";
  qm guest exec $((std+4)) cat /proc/sys/net/ipv4/ip_forward | jq -r '."out-data"';
  echo "$c_lgreen --- Маршруты BR-RTR $c_null";
  qm guest exec $((std+4)) ip \-- -br -c r | jq -r '."out-data"' | grep -v lo;
echo;
#dns_hqsrv=$(qm guest exec $((std+2)) cat /etc/hostname | jq -r '."out-data"');
#dns_hqcli=$(qm guest exec $((std+3)) cat /etc/hostname | jq -r '."out-data"');
#dns_brsrv=$(qm guest exec $((std+5)) cat /etc/hostname | jq -r '."out-data"');
echo;
#pressEnter;

# --- Networking interconnection
echo "$c_info---------------- Проверка сетевой связанности с узла BR-SRV -------------$c_null";
  echo "$c_yellow ---  ping в Интернет  $c_null"
  qm guest exec $((std+5)) ping \-- -c 3 8.8.8.8 | jq -r '."out-data"';
  # hqr_tu=$(qm guest exec $((std+1)) ip \-- -br a | jq -r '."out-data"' | grep tun | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
  # brr_tu=$(qm guest exec $((std+2)) ip \-- -br a | jq -r '."out-data"' | grep tun | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
  if [ -z $brr_tu ]; 
  then
   echo "$c_lred Туннель не настроен. Сетевой связанности с сегментом  HQ  нет $c_null"
  else
  echo "$c_yellow --- связь с HQ-SRV $c_null "
  qm guest exec $((std+5)) ping \-- -c 2 $hqsrv | jq -r '."out-data"';
  echo "$c_yellow ---  трассировка пакетов от  BR-SRV до HQ-SRV $c_null"
  qm guest exec $((std+5)) traceroute $hqsrv | jq -r '."out-data"';
  echo "$c_yellow ---  трассировка пакетов от BR-SRV до HQ-CLI  $c_null"
  qm guest exec $((std+5)) traceroute $hqcli | jq -r '."out-data"';
  fi
echo;
echo "$c_info---------------- Проверка сетевой связанности с узла HQ-SRV -------------$c_null";
  echo "$c_yellow   ping в Интернет  $c_null"
  qm guest exec $((std+2)) ping \-- -c 3 8.8.8.8 | jq -r '."out-data"';
  if [ -z $hqr_tu ]; 
  then
   echo "$c_lred Туннель не настроен. Сетевой связанности с сегментом  BR  нет $c_null"
  else
  #echo "$c_yellow   связь с BR-SRV $c_null "
  #qm guest exec $((std+2)) ping \-- -c 2 $brsrv | jq -r '."out-data"';
  echo "$c_yellow   связь с HQ-CLI $c_null "
  qm guest exec $((std+2)) ping \-- -c 2 $hqcli | jq -r '."out-data"';
  #echo "$c_yellow   трассировка пакетов от  HQ-SRV до BR-SRV $c_null"
  #qm guest exec $((std+2)) traceroute $brsrv | jq -r '."out-data"';
  fi
echo;
#pressEnter;

# --- NAT
echo "$c_info------------ Проверка NAT на ISP (iptables) ------------------$c_null";
  echo "$c_lgreen --- NAT на ISP (iptables)  $c_null";
# qm guest exec $std cat /etc/sysconfig/iptables | jq -r '."out-data"' | grep "MASQUERADE"
  qm guest exec $std iptables-save | jq -r '."out-data"' | grep "MASQUERADE"
  echo "$c_lgreen --- статус службы  iptables  $c_null";
  qm guest exec $std systemctl status iptables | jq -r '."out-data"' | grep "Active"
  echo;
#  echo "$c_lgreen --- NAT на HQ-RTR (iptables)  $c_null";
#  qm guest exec $((std+1)) cat /etc/sysconfig/iptables | jq -r '."out-data"' | grep "MASQUERADE"
#  echo "$c_lgreen --- статус службы  iptables  $c_null";
#  qm guest exec $((std+1)) systemctl status iptables | jq -r '."out-data"' | grep "Active"
#  echo;
#  echo "$c_lgreen --- NAT на BR-RTR (iptables)  $c_null";
#  qm guest exec $((std+4)) cat /etc/sysconfig/iptables | jq -r '."out-data"' | grep "MASQUERADE"
#  echo "$c_lgreen --- статус службы  iptables  $c_null";
#  qm guest exec $((std+4)) systemctl status iptables | jq -r '."out-data"' | grep "Active"
#echo;
#pressEnter;

# 1.3 --- Users
tire;
echo "$c_info 1.3 ------------ Создание и настройка пользователей ------------$c_null";
  echo "$c_lgreen --- Проверка пользователей на  HR-SRV $c_null";
  qm guest exec $((std+2)) cat /etc/passwd | jq -r '."out-data"' | grep sshuser
  qm guest exec $((std+2)) id sshuser | jq -r '."out-data"' | grep sshuser | iconv -f utf-8 -t latin1
  qm guest exec $((std+2)) cat /etc/sudoers | jq -r '."out-data"' | grep sshuser 
  echo;
  echo "$c_lgreen --- Проверка пользователей на  BR-SRV $c_null";
  qm guest exec $((std+5)) cat /etc/passwd | jq -r '."out-data"' | grep sshuser
  qm guest exec $((std+5)) id sshuser | jq -r '."out-data"' | grep sshuser | iconv -f utf-8 -t latin1
  qm guest exec $((std+5)) cat /etc/sudoers | jq -r '."out-data"' | grep sshuser 
  echo;
  echo "$c_lgreen --- Проверка пользователей на  HQ-RTR $c_null";
  qm guest exec $((std+1)) cat /etc/passwd | jq -r '."out-data"' | grep net_admin
  qm guest exec $((std+1)) cat /etc/sudoers | jq -r '."out-data"' | grep net_admin 
  echo;
  echo "$c_lgreen --- Проверка пользователей на  BR-RTR $c_null";
  qm guest exec $((std+4)) cat /etc/passwd | jq -r '."out-data"' | grep net_admin
  qm guest exec $((std+4)) cat /etc/sudoers | jq -r '."out-data"' | grep net_admin
echo;
#pressEnter;

# 1.4 --- Виртуальный коммутатор HQ-SW
tire; echo "$c_info 1.4 ---- Виртуальный коммутатор реализован средствами $c_lred ProxMox 8.2 $c_info ---------- $c_null"; echo;

# 1.5 --- SSH
tire;
echo "$c_info 1.5 ----------------- Проверка настройки SSH ----------------------------$c_null";
  #ssh \-- root@192.168.1.1 -p 2025 | jq -r '."out-data"';
  echo "$c_yellow --- SSH на сервере HQ-SRV $c_null";
  qm guest exec $((std+2)) cat /etc/openssh/sshd_config | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep "Port ";
  qm guest exec $((std+2)) cat /etc/openssh/sshd_config | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep "PermitRootLogin ";
  qm guest exec $((std+2)) cat /etc/openssh/sshd_config | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep "MaxAuthTries ";
  qm guest exec $((std+2)) cat /etc/openssh/sshd_config | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep "AllowUsers ";
  qm guest exec $((std+2)) cat /etc/openssh/sshd_config | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep -i banner ;
  b1=$(qm guest exec $((std+2)) cat /etc/openssh/sshd_config | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep -i banner) ;
  echo -n "$c_lgreen Banner  - $c_null";
  qm guest exec $((std+2)) cat ${b1:7} | jq -r '."out-data"' | grep -v '^$\|^\s*\#';
  echo;
  echo "$c_yellow --- SSH на сервере BR-SRV $c_null";
  qm guest exec $((std+5)) cat /etc/openssh/sshd_config | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep "Port ";
  qm guest exec $((std+5)) cat /etc/openssh/sshd_config | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep "PermitRootLogin ";
  qm guest exec $((std+5)) cat /etc/openssh/sshd_config | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep "MaxAuthTries ";
  qm guest exec $((std+5)) cat /etc/openssh/sshd_config | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep "AllowUsers ";
  qm guest exec $((std+5)) cat /etc/openssh/sshd_config | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep -i banner ;
  b1=$(qm guest exec $((std+3)) cat /etc/openssh/sshd_config | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep -i banner) ;
  echo -n "$c_lgreen Banner  - $c_null";
  qm guest exec $((std+5)) cat ${b1:7} | jq -r '."out-data"' | grep -v '^$\|^\s*\#';

  echo "$c_yellow --- SSH на роутере HQ-RTR $c_null";
  qm guest exec $((std+1)) cat /etc/openssh/sshd_config | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep "Port ";
  qm guest exec $((std+1)) cat /etc/openssh/sshd_config | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep "PermitRootLogin ";
  qm guest exec $((std+1)) cat /etc/openssh/sshd_config | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep "MaxAuthTries ";
  qm guest exec $((std+1)) cat /etc/openssh/sshd_config | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep "AllowUsers ";
  qm guest exec $((std+1)) cat /etc/openssh/sshd_config | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep -i banner ;
  b1=$(qm guest exec $((std+1)) cat /etc/openssh/sshd_config | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep -i banner) ;
  echo -n "$c_lgreen Banner  - $c_null";
  qm guest exec $((std+1)) cat ${b1:7} | jq -r '."out-data"' | grep -v '^$\|^\s*\#';
  echo;
  echo "$c_yellow --- SSH на роутере BR-RTR $c_null";
  qm guest exec $((std+4)) cat /etc/openssh/sshd_config | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep "Port ";
  qm guest exec $((std+4)) cat /etc/openssh/sshd_config | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep "PermitRootLogin ";
  qm guest exec $((std+4)) cat /etc/openssh/sshd_config | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep "MaxAuthTries ";
  qm guest exec $((std+4)) cat /etc/openssh/sshd_config | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep "AllowUsers ";
  qm guest exec $((std+4)) cat /etc/openssh/sshd_config | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep -i banner ;
  b1=$(qm guest exec $((std+4)) cat /etc/openssh/sshd_config | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep -i banner) ;
  echo -n "$c_lgreen Banner  - $c_null";
  qm guest exec $((std+4)) cat ${b1:7} | jq -r '."out-data"' | grep -v '^$\|^\s*\#';
echo;
#pressEnter;

# 1.6 --- Tunnel
tire;
echo "$c_info 1.6 --------- Проверка настройки туннеля GRE между HQ-RTR и  BR-RTR --------$c_null";
  echo "$c_lgreen --- туннель HQ-RTR $c_null";
  hqr_tu=$(qm guest exec $((std+1)) ip \-- -br a | jq -r '."out-data"' | grep tun | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
  if [ -z $hqr_tu ];
  then
   hqr_tu=$(qm guest exec $((std+1)) ip \-- -br a | jq -r '."out-data"' | grep gre | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
  fi
  echo "tunnel = " $hqr_tu;
  echo "$c_lgreen --- туннель BR-RTR $c_null";
  brr_tu=$(qm guest exec $((std+4)) ip \-- -br a | jq -r '."out-data"' | grep tun | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
  if [ -z $brr_tu ];
  then
   brr_tu=$(qm guest exec $((std+4)) ip \-- -br a | jq -r '."out-data"' | grep gre | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
  fi
  echo "tunnel = " $brr_tu;
  echo;
  echo "$c_lgreen --- связанность по туннелю между BR-RTR и HQ-RTR $c_null";
  qm guest exec $((std+1)) ping \-- -c 2 $brr_tu  | jq -r '."out-data"'
  echo;

# 1.7. --- FRR ospf
tire;
echo "$c_info 1.7 --------- Проверка настройки динамической маршрутизации  FRR  --------$c_null";
  echo "$c_info --- HQ-RTR $c_null";
  echo "$c_lgreen --- содержание файла  /etc/frr/daemons $c_null";
  qm guest exec $((std+1)) cat /etc/frr/daemons | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep yes;
  echo "$c_lgreen --- статус службы  frr  $c_null";
  qm guest exec $((std+1)) systemctl status frr | jq -r '."out-data"' | grep "Active";
  echo "$c_lgreen --- содержание файла  /etc/frr/frr.conf  $c_null";
  qm guest exec $((std+1)) cat /etc/frr/frr.conf | jq -r '."out-data"' ;
  echo;
  echo "$c_info --- BR-RTR $c_null";
  echo "$c_lgreen --- содержание файла  /etc/frr/daemons  $c_null";
  qm guest exec $((std+4)) cat /etc/frr/daemons | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep yes;
  echo "$c_lgreen --- статус службы  frr  $c_null";
  qm guest exec $((std+4)) systemctl status frr | jq -r '."out-data"' | grep "Active";
  echo "$c_lgreen --- содержание файла  /etc/frr/frr.conf  $c_null";
  qm guest exec $((std+4)) cat /etc/frr/frr.conf | jq -r '."out-data"' ;
echo;
#pressEnter;

# 1.8 --- NAT
tire;
echo "$c_info 1.8 ------------ Проверка настройки NAT на роутерах HQ-RTR и BR-RTR (iptables) ------------------$c_null";
#  echo "$c_lgreen --- NAT на ISP (iptables)  $c_null";
#  qm guest exec $std cat /etc/sysconfig/iptables | jq -r '."out-data"' | grep "MASQUERADE"
#  echo "$c_lgreen --- статус службы  iptables  $c_null";
#  qm guest exec $std systemctl status iptables | jq -r '."out-data"' | grep "Active"
#  echo;
  echo "$c_lgreen --- NAT на HQ-RTR (iptables)  $c_null";
  qm guest exec $((std+1)) iptables \-- -t nat -L -v  | jq -r '."out-data"' | grep "MASQUERADE"
  echo "$c_lgreen --- статус службы  iptables  $c_null";
  qm guest exec $((std+1)) systemctl status iptables | jq -r '."out-data"' | grep "Active"
  echo;
  echo "$c_lgreen --- NAT на BR-RTR (iptables)  $c_null";
  qm guest exec $((std+4)) iptables \-- -t nat -L -v  | jq -r '."out-data"' | grep "MASQUERADE"
# qm guest exec $((std+4)) cat /etc/sysconfig/iptables | jq -r '."out-data"' | grep "MASQUERADE"
  echo "$c_lgreen --- статус службы  iptables  $c_null";
  qm guest exec $((std+4)) systemctl status iptables | jq -r '."out-data"' | grep "Active"
echo;
#pressEnter;


# 1.9 --- DHCP
tire;
echo "$c_info 1.9 --------- Проверка настройки DHCP  ---------------------------------------------$c_null";
  b1=$(qm guest exec $((std+1)) systemctl status dnsmasq | jq -r '."out-data"' | grep "Active");
  b2=$(qm guest exec $((std+1)) systemctl status dhcpd | jq -r '."out-data"' | grep "Active");
  b1=${b1:13:6}
  b2=${b2:13:6}
  # echo "b1=" $b1
  # echo "b2=" $b2

  if [ $b1 = "active" ];
  then
     echo "$c_info --- Проверка настройки DHCP (dnsmasq) на HQ-RTR $c_null";
     echo "$c_lgreen --- содержание файла  /etc/dnsmasq.conf  $c_null";
     qm guest exec $((std+1)) cat /etc/dnsmasq.conf | jq -r '."out-data"' | grep -v '^$\|^\s*\#';
     echo "$c_lgreen --- статус службы  dnsmasq  $c_null";
     qm guest exec $((std+1)) systemctl status dnsmasq | jq -r '."out-data"' | grep "Active";
     echo;
  elif [ $b2 = "active" ];
  then
     echo "$c_info --- Проверка настройки DHCP (dhcp-server) на HQ-RTR $c_null";
     echo "$c_lgreen --- содержание файла  /etc/dhcp/dhcpd.conf  $c_null";
     qm guest exec $((std+1)) cat /etc/dhcp/dhcpd.conf | jq -r '."out-data"' | grep -v '^$\|^\s*\#';
     echo "$c_lgreen --- статус службы  dhcp  $c_null";
     qm guest exec $((std+1)) systemctl status dhcpd | jq -r '."out-data"' | grep "Active";
     echo;
  else echo "$c_lred служба DHCP не настроена $c_null";

  fi
  echo;

  echo "$c_info --- Проверка динамического адреса на HQ-CLI $c_null";
  echo "$c_lgreen --- содержание файла  options  $c_null";
  qm guest exec $((std+3)) cat /etc/net/ifaces/enp7s1/options | jq -r '."out-data"' | grep BOOTPROTO;
  echo "$c_lgreen --- настройка интерфейса enp7s1  $c_null";
  qm guest exec $((std+3)) ip \-- -c a | jq -r '."out-data"' | grep -v lo | grep dynamic;
  qm guest exec $((std+3)) ip \-- -c a | jq -r '."out-data"' | grep enp6s18;
echo;
#pressEnter;


# 1.10 --- DNS
tire;
echo "$c_info 1.10 --------------- Проверка настройки DNS -----------------------------$c_null";
  #dns_brrtr=$(qm guest exec $((std+4)) cat /etc/hostname | jq -r '."out-data"');
  #dns_isp=$(qm guest exec $std cat /etc/hostname | jq -r '."out-data"');
  #dns_hqrtr=$(qm guest exec $((std+1)) cat /etc/hostname | jq -r '."out-data"');
  #dns_hqsrv=$(qm guest exec $((std+2)) cat /etc/hostname | jq -r '."out-data"');
  #dns_hqcli=$(qm guest exec $((std+3)) cat /etc/hostname | jq -r '."out-data"');
  #dns_brsrv=$(qm guest exec $((std+5)) cat /etc/hostname | jq -r '."out-data"');
  dns1=$(qm guest exec $((std+2)) rpm \-- -qa | jq -r '."out-data"' | grep dnsmasq);
  # dns2=$(qm guest exec $((std+2)) rpm \-- -qa | jq -r '."out-data"' | grep bind9);
  if [ -z $dns1 ];
  then
     echo "$c_info --- Проверка настройки DNS (bind9) на HQ-SRV $c_null";
     echo "$c_lgreen --- содержание файла  /etc/named.conf  $c_null";
     qm guest exec $((std+2)) cat /etc/named.conf | jq -r '."out-data"' | grep -v '^$\|^\s*\#';
     echo "$c_lgreen --- статус службы  bind9  $c_null";
     qm guest exec $((std+2)) systemctl status named | jq -r '."out-data"' | grep "Active";
     echo;
  else
     echo "$c_info --- Проверка настройки DNS (dnsmasq) на HQ-SRV $c_null";
     echo "$c_lgreen --- содержание файла  dnsmasq.conf  $c_null";
     qm guest exec $((std+2)) cat /etc/dnsmasq.conf | jq -r '."out-data"' | grep -v '^$\|^\s*\#';
     echo "$c_lgreen --- статус службы  dnsmasq  $c_null";
     qm guest exec $((std+2)) systemctl status dnsmasq | jq -r '."out-data"' | grep "Active";
     echo;
  fi
  echo "$c_info----------------------  Проверка DNS  на HQ-CLI  ------------------------$c_null";
  echo "$c_lgreen --- содержание файла  resolv.conf  $c_null";
  qm guest exec $((std+3)) cat /etc/resolv.conf | jq -r '."out-data"'   | grep -v '^$\|^\s*\#';
  echo "$c_yellow --- ping HQ-RTR  $c_null";
  dns_hqrtr=$(qm guest exec $((std+1)) cat /etc/hostname | jq -r '."out-data"');
  echo "$c_lgreen hostname  ---  $dns_hqrtr $c_null";
  qm guest exec $((std+1)) ping \-- -c 2 hq-rtr.au-team.irpo | jq -r '."out-data"';
  echo "$c_yellow --- ping BR-RTR  $c_null";
  dns_brrtr=$(qm guest exec $((std+4)) cat /etc/hostname | jq -r '."out-data"');
  echo "$c_lgreen hostname  ---  $dns_brrtr $c_null";
  qm guest exec $((std+4)) ping \-- -c 2 br-rtr.au-team.irpo | jq -r '."out-data"';
  echo "$c_yellow --- ping BR-SRV $c_null";
  dns_brsrv=$(qm guest exec $((std+5)) cat /etc/hostname | jq -r '."out-data"');
  echo "$c_lgreen hostname  ---  $dns_brsrv $c_null";
  qm guest exec $((std+5)) ping \-- -c 2 br-srv.au-team.irpo | jq -r '."out-data"';
echo;
#pressEnter;

# 1.11 --- Timedate
tire;
echo "$c_info 1.11 ------------- Проверка настройки часового пояса -------------------$c_null";
  echo "$c_lgreen --- Проверка часового пояса на ISP $c_null";
  qm guest exec $std timedatectl status | jq -r '."out-data"' | grep "Time zone";
  echo "$c_lgreen --- Проверка часового пояса на HQ-RTR $c_null";
  qm guest exec $((std+1)) timedatectl status | jq -r '."out-data"' | grep "Time zone";
  echo "$c_lgreen --- Проверка часового пояса на BR-RTR $c_null";
  qm guest exec $((std+4)) timedatectl status | jq -r '."out-data"' | grep "Time zone";
  echo "$c_lgreen --- Проверка часового пояса на HQ-SRV $c_null";
  qm guest exec $((std+2)) timedatectl status | jq -r '."out-data"' | grep "Time zone";
  echo "$c_lgreen --- Проверка часового пояса на HQ-CLI $c_null";
  qm guest exec $((std+3)) timedatectl status | jq -r '."out-data"' | grep "Time zone";
  echo "$c_lgreen --- Проверка часового пояса на BR-SRV $c_null";
  qm guest exec $((std+5)) timedatectl status | jq -r '."out-data"' | grep "Time zone";
echo -e "\n\n";
echo;
}

function m2 {
# Модуль 2
echo -e "$c_error                                     МОДУЛЬ 2 $c_null \n\n";


# 2.1 --- Samba AD
tire;
echo "$c_info 2.1 --------------   Проверка запуска контроллера домена  Samba на BR-SRV  ----------$c_null";
  qm guest exec $((std+5)) systemctl status samba.service | jq -r '."out-data"' | grep "Active";
  echo "$c_lgreen---  Конфигурация Samba AD (samba-tool) $c_null";
  qm guest exec $((std+5)) samba-tool domain info 127.0.0.1 | jq -r '."out-data"';
  echo "$c_lgreen---  Список пользователей Samba AD $c_null";
  qm guest exec $((std+5)) samba-tool user list  | jq -r '."out-data"' | grep hquser;
  echo "$c_lgreen---  Количество пользователей из файлв Users.csv $c_null";
  qm guest exec $((std+5)) samba-tool user list | jq -r '."out-data"' | grep -v hquser | wc -l ;
  #echo "$c_info---------------------   Настройка (smb.conf) -----------------------$c_null";
  #qm guest exec $((std+5)) cat /etc/samba/smb.conf | jq -r '."out-data"' | grep -v '^$\|^\s*\#';
  #echo "$c_info--------------   Cоздание и настройка каталогов Samba  ----------------$c_null";
  #echo "$c_error------------------------- каталог /srv -------------------------------$c_null";
  #qm guest exec $((std+1)) ls \-- -all /srv | jq -r '."out-data"';
echo;
#pressEnter;

# 2.2 --- RAID RAID
tire;
echo "$c_info 2.2 --------------- Проверка RAID  на HQ-SRV --------------------------$c_null";
  qm guest exec $((std+2)) lsblk | jq -r '."out-data"' | iconv -f utf-8 -t latin1;
  echo "$c_lgreen --- наличие раздела raid  $c_null";
  qm guest exec $((std+2)) cat /proc/mdstat | jq -r '."out-data"';
  b1=$(qm guest exec $((std+2)) ls / | jq -r '."out-data"' | grep "raid");
  if [ "$b1" == "raid" ];
     then echo "Каталог $c_lgreen /raid $c_null создан";
     else echo "$c_error нет каталога /raid $c_null"
  fi
  echo "$c_lgreen --- монтирование раздела md0p1  $c_null";
  qm guest exec $((std+2)) cat /etc/fstab | jq -r '."out-data"' | grep "/raid";
  echo;
# 2.3 ---  NFS
  echo "$c_info 2.3 ---------- Проверка настройки файлового сервера NFS на HQ-SRV --------$c_null";
  qm guest exec $((std+2)) cat /etc/exports | jq -r '."out-data"';
  echo "$c_lgreen --- статус службы  nfs  $c_null";
  qm guest exec $((std+2)) systemctl status nfs | jq -r '."out-data"' | grep "Active";
  echo;
  echo "$c_info--- монтирование NFS на HQ-CLI $c_null";
  qm guest exec $((std+3)) cat /etc/fstab | jq -r '."out-data"' | grep "/mnt/nfs";
  echo "$c_lgreen --- статус службы  nfs  $c_null";
  qm guest exec $((std+3)) systemctl status nfs-client.target | jq -r '."out-data"' | grep "Loaded";
echo;
#pressEnter;

# 2.4 --- NTP chrony
tire;
echo "$c_info 2.4 -------- Проверка настройки сервера времени NTP (chrony) на ISP  -----------$c_null";
  qm guest exec $((std+0)) cat /etc/chrony.conf | jq -r '."out-data"'  | grep -v '^$\|^\s*\#' | grep pool
  qm guest exec $((std+0)) cat /etc/chrony.conf | jq -r '."out-data"'  | grep -v '^$\|^\s*\#' | grep server;
  qm guest exec $((std+0)) cat /etc/chrony.conf | jq -r '."out-data"'  | grep -v '^$\|^\s*\#' | grep stratum;
  qm guest exec $((std+0)) cat /etc/chrony.conf | jq -r '."out-data"'  | grep -v '^$\|^\s*\#' | grep allow;
  echo "$c_lgreen --- статус службы  chrony  $c_null";
  qm guest exec $((std+0)) systemctl status chronyd | jq -r '."out-data"' | grep "Active";
  echo "$c_info--- Проверка синхронизации NTP на HQ-RTR $c_null";
  qm guest exec $((std+1)) cat /etc/chrony.conf | jq -r '."out-data"' | grep "server" | grep -v '^$\|^\s*\#';
  qm guest exec $((std+1)) cat /etc/chrony.conf | jq -r '."out-data"' | grep "pool" | grep -v '^$\|^\s*\#';
  echo "$c_lgreen --- синхронизация  $c_null";
  qm guest exec $((std+1)) chronyc tracking | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep Reference;
  qm guest exec $((std+1)) chronyc tracking | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep Leap;
  echo "$c_lgreen --- статус службы  chrony  $c_null";
  qm guest exec $((std+1)) systemctl status chronyd | jq -r '."out-data"' | grep "Active";
  echo "$c_info--- Проверка синхронизации NTP на BR-RTR $c_null";
  qm guest exec $((std+4)) cat /etc/chrony.conf | jq -r '."out-data"' | grep "server" | grep -v '^$\|^\s*\#';
  qm guest exec $((std+4)) cat /etc/chrony.conf | jq -r '."out-data"' | grep "pool" | grep -v '^$\|^\s*\#';
  echo "$c_lgreen --- синхронизация  $c_null";
  qm guest exec $((std+4)) chronyc tracking | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep Reference;
  qm guest exec $((std+4)) chronyc tracking | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep Leap;
  echo "$c_lgreen --- статус службы  chrony  $c_null";
  qm guest exec $((std+4)) systemctl status chronyd | jq -r '."out-data"' | grep "Active";
  echo "$c_info--- Проверка синхронизации NTP на HQ-SRV $c_null";
  qm guest exec $((std+2)) cat /etc/chrony.conf | jq -r '."out-data"' | grep "server" | grep -v '^$\|^\s*\#';
  qm guest exec $((std+2)) cat /etc/chrony.conf | jq -r '."out-data"' | grep "pool" | grep -v '^$\|^\s*\#';
  echo "$c_lgreen --- синхронизация  $c_null";
  qm guest exec $((std+2)) chronyc tracking | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep Reference;
  qm guest exec $((std+2)) chronyc tracking | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep Leap;
  echo "$c_lgreen --- статус службы  chrony  $c_null";
  qm guest exec $((std+2)) systemctl status chronyd | jq -r '."out-data"' | grep "Active";
  echo "$c_info--- Проверка синхронизации NTP на HQ-CLI $c_null";
  qm guest exec $((std+3)) cat /etc/chrony.conf | jq -r '."out-data"' | grep "server" | grep -v '^$\|^\s*\#';
  qm guest exec $((std+3)) cat /etc/chrony.conf | jq -r '."out-data"' | grep "pool" | grep -v '^$\|^\s*\#';
  echo "$c_lgreen --- синхронизация  $c_null";
  qm guest exec $((std+3)) chronyc tracking | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep Reference;
  qm guest exec $((std+3)) chronyc tracking | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep Leap;
  echo "$c_lgreen --- статус службы  chrony  $c_null";
  qm guest exec $((std+3)) systemctl status chronyd | jq -r '."out-data"' | grep "Active";
  echo "$c_info--- Проверка синхронизации NTP на BR-SRV $c_null";
  qm guest exec $((std+5)) cat /etc/chrony.conf | jq -r '."out-data"' | grep "server" | grep -v '^$\|^\s*\#';
  qm guest exec $((std+5)) cat /etc/chrony.conf | jq -r '."out-data"' | grep "pool" | grep -v '^$\|^\s*\#';
  echo "$c_lgreen --- синхронизация  $c_null";
  qm guest exec $((std+5)) chronyc tracking | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep Reference;
  qm guest exec $((std+5)) chronyc tracking | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep Leap;
  echo "$c_lgreen --- статус службы  chrony  $c_null";
  qm guest exec $((std+5)) systemctl status chronyd | jq -r '."out-data"' | grep "Active" ;
echo;
#pressEnter;

# 2.5 --- Ansible
tire;
echo "$c_info 2.4 --------------- Проверка установки Ansible на BR-SRV --------------------------$c_null";
  qm guest exec $((std+5)) rpm \-- -q ansible | jq -r '."out-data"'
  echo "$c_lgreen --- содержание файла  ansible.cfg  $c_null";
  qm guest exec $((std+5)) cat /etc/ansible/ansible.cfg | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep -v "\[";
  b1=$(qm guest exec $((std+5)) cat /etc/ansible/ansible.cfg | jq -r '."out-data"' | grep -v '^$\|^\s*\#' | grep -v "\[" | grep inventory | sed 's/^.*=//');
  # echo  $b1
#  echo "$c_lgreen --- содержание файла  инвентаря hosts  $c_null";
# qm guest exec $((std+5)) cat $b1 | jq -r '."out-data"'
#  qm guest exec $((std+5)) cat /etc/ansible/hosts | jq -r '."out-data"'
  echo "$c_lgreen --- содержание файла  инвентаря $c_lred $b1  $c_null";
  qm guest exec $((std+5)) cat $b1 | jq -r '."out-data"'
#  qm guest exec $((std+5)) cat /etc/ansible/inventory.yml | jq -r '."out-data"'
  echo "$c_lgreen --- проверка работы Ansible $c_null";
  qm guest exec $((std+5)) ansible all \-- -m ping | jq -r '."out-data"'
echo;
#pressEnter;

# 2.6 --- Docker
tire;
echo "$c_info 2.5 --------------- Проверка установки Docker на BR-SRV --------------------------$c_null";
  qm guest exec $((std+5)) systemctl status docker | jq -r '."out-data"' | grep "Active";
  echo "$c_lgreen --- запуск контейнеров на BR-SRV $c_null";
  qm guest exec $((std+5)) docker ps | jq -r '."out-data"' ;
#  echo "$c_lgreen --- зайдите на HQ-CLI в браузер и наберите $c_yellow http://wiki.au-team.irpo/ $c_null";
#  brsrv=$(qm guest exec $((std+5)) ip \-- -br a | jq -r '."out-data"' | grep ens18 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
#  echo "$c_lgreen ---    (если не получится по имени, тогда $c_yellow http://$brsrv/ $c_null";
# http://wiki.au-team.irpo/
echo;
#pressEnter;

# 2.7 --- Web
tire;
echo "$c_info 2.7 --------------- Проверка установки приложений на HQ-SRV --------------------------$c_null";
  echo "$c_lgreen --- запуск службы $c_yellow mysql $c_null";
  qm guest exec $((std+2)) systemctl status mysqld | jq -r '."out-data"' | grep "Active";
  echo "$c_lgreen --- запуск службы $c_yellow appahe2 $c_null";
  qm guest exec $((std+2)) systemctl status httpd2 | jq -r '."out-data"' | grep "Active";
#  echo "$c_lgreen --- зайдите на HQ-CLI в браузер и наберите $c_yellow http://moodle.au-team.irpo/ $c_null";
# hqsrv=$(qm guest exec $((std+2)) ip \-- -br a | jq -r '."out-data"' | grep ens18 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
#  echo "$c_lgreen ---    (если не получится по имени, тогда $c_yellow http://$hqsrv/ $c_null";
echo;


# 2.8 --- Port map forward
tire;
echo "$c_info 2.8 --------------- Проброс портов на BR-RTR (80-8080, 2026) --------------------$c_null";
  echo "$c_lgreen --- статус службы  iptables  $c_null";
  qm guest exec $((std+4)) systemctl status iptables | jq -r '."out-data"' | grep "Active";
  echo "$c_lgreen --- содержание файла iptables  $c_null";
#  qm guest exec $((std+4)) cat /etc/sysconfig/iptables | jq -r '."out-data"' | grep -v '^$\|^\s*\#';
  qm guest exec $((std+4)) iptables-save | jq -r '."out-data"';
  echo "$c_info--------------- Проброс портов на HQ-RTR (2026) ------------------------------$c_null";
  echo "$c_lgreen --- статус службы  iptables  $c_null";
  qm guest exec $((std+1)) systemctl status iptables | jq -r '."out-data"' | grep "Active";
  echo "$c_lgreen --- содержание файла iptables  $c_null";
#  qm guest exec $((std+1)) cat /etc/sysconfig/iptables | jq -r '."out-data"' | grep -v '^$\|^\s*\#';
  qm guest exec $((std+1)) iptables-save | jq -r '."out-data"';
echo;
#pressEnter;


# 2.9 --- Yandex browser
tire;
echo "$c_info 2.11 ------------ Проверка установки Yandex Browser на  HR-CLI  -------------------$c_null";
  echo "$c_lgreen --- статус службы yandex-browser  $c_null";
  qm guest exec $((std+3)) rpm \-- -qa | jq -r '."out-data"' | grep yandex
echo;
}

function m3 {
# Модуль 3
echo;
echo -e "$c_error                                     МОДУЛЬ 3 $c_null \n\n";

# 3.1 --- Samba AD Migration
tire;
echo "$c_info 3.1 --------------   Импорт пользователей в домена  Samba   ----------------$c_null";
  echo "$c_lgreen---  Количество пользователей из файлв Users.csv $c_null";
  qm guest exec $((std+5)) samba-tool user list | jq -r '."out-data"' | grep -v hquser | wc -l ;
  #echo "$c_info---------------------   Настройка (smb.conf) -----------------------$c_null";
  #qm guest exec $((std+5)) cat /etc/samba/smb.conf | jq -r '."out-data"' | grep -v '^$\|^\s*\#';
  #echo "$c_info--------------   Cоздание и настройка каталогов Samba  ----------------$c_null";
  #echo "$c_error------------------------- каталог /srv -------------------------------$c_null";
  #qm guest exec $((std+1)) ls \-- -all /srv | jq -r '."out-data"';
echo;
#pressEnter;
# 3.2 --- Nginx
tire;
echo "$c_info 3.2 ------------ Проверка установки и запуска Nginx  на  ISP  ------------------$c_null";
  echo "$c_lgreen --- статус службы  nginx  $c_null";
  qm guest exec $((std+0)) systemctl status nginx | jq -r '."out-data"' | grep "Active"
  echo "$c_lgreen --- содержание файла nginx.conf  $c_null";
  qm guest exec $((std+0)) cat /etc/nginx/sites-available.d/default.conf | jq -r '."out-data"'| grep -v '^$\|^\s*\#';
  qm guest exec $((std+0)) cat /etc/nginx/sites-available.d/proxy | jq -r '."out-data"' | grep -v '^$\|^\s*\#';
echo;
#pressEnter;

# 3.3 --- Aut
tire;
echo "$c_info 3.3 ------------ Проверка web-based аутентификации на  ISP  ------------------$c_null";
  echo "$c_lgreen --- содержание файла /etc/nginx/.htpasswd  $c_null";
  qm guest exec $((std+0)) cat /etc/nginx/.htpasswd | jq -r '."out-data"'| grep -v '^$\|^\s*\#';
echo;
echo "$c_lgreen --- зайдите на HQ-CLI в браузер и наберите $c_yellow http://web.au-team.irpo/ $c_null";
#pressEnter;


# 3.4 --- Certification
tire;
echo "$c_info 3.4 ----------   Проверка настройки центра сертификации на HQ-SRV  ----------------$c_null";
  #qm guest exec $((std+2)) openssl ca  | grep ssl
  echo "$c_lgreen --- просмотр сертификата   $c_null";
  qm guest exec $((std+2)) openssl x509 -text -noout -in ca.cer | jq -r '."out-data"';
echo;
#pressEnter;


# 3.5 --- Мониторинг atop
tire;
echo "$c_info 3.5 -------  Проверка утилиты состояния сервера atop на HQ-SRV ---------------------$c_null";
  echo "$c_lgreen ------- статус загрузки пакета atop  $c_null";
  qm guest exec $((std+2)) rpm \-- -q atop  | jq -r '."out-data"'
  echo "$c_lgreen --- статус службы atop  $c_null";
  qm guest exec $((std+2)) systemctl status atop | jq -r '."out-data"' | grep "Active";
  echo "$c_lgreen --- содержание файла /etc/default/atop  $c_null";
  qm guest exec $((std+2)) cat /etc/default/atop | jq -r '."out-data"'
  echo "$c_lgreen --- проверка журнала логов $c_null";
  qm guest exec $((std+2)) ls /var/log/atop | jq -r '."out-data"'
  echo "$c_lgreen --- смотри логи в ручную /var/log/atop $c_null";
  echo;
#pressEnter;

# 3.6 --- Принт-сервер cups
tire;
echo "$c_info 3.6 -------  Проверка настройки принт-сервера cups на HQ-SRV ---------------------$c_null";
  echo "$c_lgreen ------- статус загрузки пакета cups  $c_null";
  qm guest exec $((std+2)) rpm \-- -q cups  | jq -r '."out-data"'
  echo "$c_lgreen --- статус службы cups  $c_null";
  qm guest exec $((std+2)) systemctl status cups | jq -r '."out-data"' | grep "Active";
  echo "$c_lgreen --- содержание файла /etc/cups/cupsd.conf  $c_null";
  qm guest exec $((std+2)) cat /etc/cups/cupsd.conf | jq -r '."out-data"'| sed -n "/<Location /,/<\/Location/p"
  echo "$c_lgreen --- проверка подключения принтера на HQ-CLI $c_null";
  qm guest exec $((std+3)) lpstat \-- -p | jq -r '."out-data"' | iconv -f utf-8 -t latin1
  echo;
#pressEnter;


# 3.7 --- Ansible инвентаризация
tire;
echo "$c_info 3.7 --------------- Проверка инвентаризации Ansible на BR-SRV -----------------------$c_null";
  echo "$c_lgreen --- содержание каталога /etc/ansible/PC_INFO  $c_null";
  qm guest exec $((std+5)) ls /etc/ansible/PC_INFO | jq -r '."out-data"'
  echo "$c_lgreen --- содержание плейбука *.yml $c_null";
  b1=$(qm guest exec $((std+5)) ls /etc/ansible/ | jq -r '."out-data"' | grep -i inv)
  echo "$c_lyellow Имя плейбука =  $c_lred $b1 $c_null";
  qm guest exec $((std+5)) cat /etc/ansible/$b1 | jq -r '."out-data"' | iconv -f utf-8 -t latin1
  echo;
  echo "$c_lgreen --- содержание отчета о HQ-SRV $c_null";
  b1=$(qm guest exec $((std+5)) ls /etc/ansible/PC_INFO/ | jq -r '."out-data"' |  grep -i hq-srv)
  qm guest exec $((std+5)) less /etc/ansible/PC_INFO/$b1 | jq -r '."out-data"' | iconv -f utf-8 -t latin1
  echo "$c_lgreen --- содержание отчета о HQ-CLI $c_null";
  b1=$(qm guest exec $((std+5)) ls /etc/ansible/PC_INFO/ | jq -r '."out-data"' |  grep -i hq-cli)
  qm guest exec $((std+5)) cat /etc/ansible/PC_INFO/$b1 | jq -r '."out-data"' | iconv -f utf-8 -t latin1
echo;
#pressEnter;

# 3.8 --- Проверка настройки fail2ban на HQ-SRV
  tire;
  echo "$c_info 3.8 -------  Проверка настройки fail2ban на HQ-SRV ---------------------$c_null";
  echo "$c_lgreen ------- статус загрузки пакета fail2ban  $c_null";
  qm guest exec $((std+2)) rpm \-- -q fail2ban  | jq -r '."out-data"'
  echo "$c_lgreen --- статус службы fail2ban  $c_null";
  qm guest exec $((std+2)) systemctl status fail2ban | jq -r '."out-data"' | grep "Active";
  echo "$c_lgreen --- содержание конфигурационного файла /etc/fail2ban/jail.conf  $c_null";
  qm guest exec $((std+2)) cat /etc/fail2ban/jail.conf | jq -r '."out-data"'
  echo;
#pressEnter;

# 3.9 --- Кибер-Бекап
  tire;
  echo "$c_info 3.9 -------  Проверка Кибер-бекап на HQ-SRV ---------------------$c_null";
  echo "$c_lgreen --- смотри в ручную  $c_null";
  echo;
#pressEnter;
  
 }

function main () {
        clear
        heads;
#	echo "$c_info    Модуль автоматической проверки стенда  Демонстрационного экзамена   $c_null"
#        echo ""
#        read -p "$c_info  Введите ID виртуальной машины ISP - $c_null" std
        echo ""
        echo "$c_lgreen+===================== Сделайте выбор   ====================+"
        echo "|  1. Запуск проверки $c_info Модуля 1$c_lgreen         ====================|"
        echo "|  2. Запуск проверки $c_info Модуля 2$c_lgreen         ====================|"
        echo "|  3. Запуск проверки $c_info Модуля 3$c_lgreen         ====================|"
        echo "+===========================================================+$c_null"
        read -p "$c_null Выбор:    "  choice
        case $choice in
                1)  m1 ; pressEnter ;;
                2)  m2 ; pressEnter ;;
                3)  m3 ; pressEnter ;;
                *)  exit 1
        esac
}

while true 
do
  main
done;
#  здесь остановился
exit




