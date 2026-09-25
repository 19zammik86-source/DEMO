cat <<EOF > /etc/chrony.conf
        pool pool.ntp.org iburst
        local stratum 5
        allow 0/0
        driftfile /var/lib/chrony/drift
        makestep 1.0 3
        ntsdumpdir /var/lib/chrony
        logdir /var/log/chrony
        EOF

        systemctl enable --now chronyd
        systemctl restart chronyd
