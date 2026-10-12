---
- name: Install iperf3 on target servers
  hosts: target_servers
  become: yes # Используем привилегии root для установки пакетов
  tasks:
    - name: Ensure iperf3 is installed
      apt:
        name: iperf3
        state: present
