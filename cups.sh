#!/bin/bash
apt-get install -y cups cups-pdf
systemctl enable --now cups
cupsctl --share-printers --remote-any
systemctl restart cups
