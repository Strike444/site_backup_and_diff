Программа для создания архива сайта через rsnapshot, выявления различий в файлах и уведомления по e-mail
Шаги для запуска:
</ol>
<li>1. Создайте папку для архивов в home</li>
<li>2. Скопируйте файлы в эту папку</li>
<li>3. Установите curlftpfs, rsnapshot, ruby</li>
<li>4. cat << EOF > /home/rsnapshot/.netrc</li>
<li>machine ftp.host.com</li>  
<li>login myuser</li>  
<li>password mypass</li> 
<li>EOF</li>
<li>5. Исправьте пути в файле doftpsync_makebackup_and_diff.sh</li>
<li>6. Исправьте ptiny.rb в строке 14 путь к файлу настроек</li>
<li>7. Если нужно исправьте в ptiny.rb строку 61 если дерево каталогов на сервере отличается</li>
<li>8. Измените настройки в файле settings.yaml</li>
<li>9. Для запуска ruby скрипта Вам понадобится gem mailfactory. Установите его командой gem install mailfactory</li>
<li>10. Создайте два правила в crontab для запуска doftpsync_makebackup_and_diff.sh и ptiny.rb командой crontab -e</li>
</ol> 
