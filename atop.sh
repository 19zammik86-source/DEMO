#!/bin/bash
apt-get install atop -y
systemctl enable --now atop
cat <<EOF > /etc/default/atop
LOGOPTS="-R"
LOGINTERVAL=420
LOGGENERATIONS=28
LOGPATH=/var/log/atop
EOF
