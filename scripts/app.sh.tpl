#!/bin/bash
# fail the pipeline if fail only once
set -euxo pipefail

mkdir /tmp/nextcloud_installation
cd /tmp/nextcloud_installation

wget https://download.nextcloud.com/server/releases/nextcloud-22.2.0.tar.bz2
cat <<EOF > nextcloud-22.2.0.tar.bz2.sha256
273dba3ce43501b897e8b78996b50329e31da2b5402866ac20b318cdaddf3e1f  nextcloud-22.2.0.tar.bz2

EOF

sha256sum -c nextcloud-22.2.0.tar.bz2.sha256 < nextcloud-22.2.0.tar.bz2

tar -xjvf nextcloud-22.2.0.tar.bz2
cp -r nextcloud /var/www

$(which python3) <<EOF
import fileinput
dirtext = """
    <Directory /var/www/nextcloud>
        Require all granted
        AllowOverride All
        Options FollowSymLinks MultiViews
        Satisfy Any

        <IfModule mod_dav.c>
            Dav off
        </IfModule>
    </Directory>

"""
filepath = '/etc/apache2/sites-available/000-default.conf'
with fileinput.FileInput(filepath, inplace = True, backup = '.bak') as f:
    for line in f:
        if line.strip() == '</VirtualHost>':
            line = line.replace(line, dirtext+line)
        if "/var/www/html" in line:
            line = line.replace("/var/www/html", "/var/www/nextcloud")
        print(line, end='')
EOF

cd /etc/apache2/sites-available
a2dissite 000-default.conf
mv 000-default.conf nextcloud.conf
a2ensite nextcloud.conf
a2enmod rewrite
a2enmod headers
a2enmod env
a2enmod dir
a2enmod mime

systemctl reload apache2

chown -R www-data:www-data /var/www/nextcloud/
cd /var/www/nextcloud/
sudo -u www-data php occ maintenance:install \
  --database "mysql" \
  --database-name "${database_name}" \
  --database-host "${database_host}" \
  --database-user "${database_user}" \
  --database-pass "${database_pass}" \
  --admin-user    "${admin_user}" \
  --admin-pass    "${admin_pass}" \
  --no-interaction

export OCC=/var/www/nextcloud/occ

export NEXTCLOUD_TRUSTED_DOMAIN_I=$(sudo -u www-data php $OCC config:system:get trusted_domains | wc -l)
sudo -u www-data php $OCC config:system:set \
  trusted_domains $NEXTCLOUD_TRUSTED_DOMAIN_I \
  --value=${app_host}
