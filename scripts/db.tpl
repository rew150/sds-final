#cloud-config
users:
  - name: nextcloud
    gecos: Nextcloud
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    groups: users, admin

repo_update: true
repo_upgrade: all
packages:
  - mariadb-server
