#!/bin/sh
# -r = mount read-only
# -o ssl = Force SSL
echo Mounting the FTP servr
curlftpfs ftp://u294559.ftp.masterhost.ru /media/remote_server -r

# Do some backup here :)
#echo performing the backup
/usr/bin/rsnapshot -c /home/strike/work/sitebackup/rsnapshot.conf daily

# Finally, unmount and disconnect from the FTP server
fusermount -u /media/remote_server

# make diff
diff --exclude="_logs" -urq daily.0/remote_server/media/remote_server/ daily.1/remote_server/media/remote_server/ > new.diff
diff --exclude="_logs" -urqN daily.0/remote_server/media/remote_server/ daily.1/remote_server/media/remote_server/ > tiny.diff
diff --exclude="_logs" -urN daily.0/remote_server/media/remote_server/ daily.1/remote_server/media/remote_server/ > full.diff

# move files to daily.0
mv full.diff tiny.diff new.diff /home/strike/work/sitebackup/daily.0/

# for crontab you may need absolut path
# diff --exclude="_logs" -urq daily.0/remote_server/ daily.1/remote_server/ > /home/serv/sitebackup/new.diff
# diff --exclude="_logs" -urqN daily.0/remote_server/ daily.1/remote_server/ > /home/serv/sitebackup/tiny.diff
# diff --exclude="_logs" -urN daily.0/remote_server/ daily.1/remote_server/ > /home/serv/sitebackup/full.diff

# # move files to daily.0
# # mv full.diff tiny.diff new.diff /home/serv/sitebackup/daily.0/
# mv /home/serv/sitebackup/full.diff /home/serv/sitebackup/daily.0/
# mv /home/serv/sitebackup/tiny.diff /home/serv/sitebackup/daily.0/
# mv /home/serv/sitebackup/new.diff /home/serv/sitebackup/daily.0/
