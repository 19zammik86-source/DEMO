cat <<EOF > /etc/chrony.conf
        server 172.16.1.1 iburst
        driftfile /var/lib/chrony/drift
        makestep 1.0 3
        rtcsync
        ntsdumpdir /var/lib/chrony
        logdir /var/log/chrony
        EOF

   
        systemctl enable --now chronyd
        systemctl restart chronyd
