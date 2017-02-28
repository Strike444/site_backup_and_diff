Программа для создания архива сайта через rsnapshot, выявления различий в файлах и уведомления по e-mail
Шаги для запуска:
1. Создайте папку для архивов в home
2. Скопируйте файлы в эту папку
3. Установите curlftpfs, rsnapshot, ruby
4. cat << EOF > /home/rsnapshot/.netrc
   machine ftp.host.com  
   login myuser  
   password mypass 
   EOF
5. Исправьте пути в файле doftpsync_makebackup_and_diff.sh
6. Исправьте ptiny.rb в строке 14 путь к файлу настроек
7. Если нужно исправьте в ptiny.rb строку 61 если дерево каталогов на сервере отличается
8. Измените настройки в файле settings.yaml
9. Для запуска ruby скрипта Вам понадобится gem mailfactory. Установите его командой gem install mailfactory
10. Создайте два правила в crontab для запуска doftpsync_makebackup_and_diff.sh и ptiny.rb командой crontab -e
 