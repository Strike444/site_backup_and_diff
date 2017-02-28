module Diff
  # read settings from yaml
  class ReadSettings
    attr_reader :options
    require 'yaml'
    def initialize
      @options = {
      :gzip => true,
      :force => false,
      }
    end
    def getSettings
      # path to yaml file
      config_file = File.join(ENV['HOME'],'/work/sitebackup/settings.yaml')
      if File.exists? config_file
        config_options = YAML.load_file(config_file)
        # merge hash
        @options.merge!(config_options)
      else
        File.open(config_file,'w') { |file| YAML::dump(@options,file) }
        STDERR.puts "Initialized configuration file in #{config_file}"
      end
    end
  end

  class DelOutFile
    def delOutFile
      rs = ReadSettings.new
      rs.getSettings
      filefordel = File.join(ENV['HOME'],rs.options["save_file"])
      if File.exist? filefordel
          FileUtils.rm(filefordel)
          puts "File #{filefordel} deleted"
      end
    end
  end

  class StringToFile
    require 'fileutils'
    def initialize smas
      @smas = smas
    end
    def writeFile
      rs = ReadSettings.new
      rs.getSettings
      savefile = File.join(ENV['HOME'],rs.options["save_file"])
      begin
        psavefile = File.open(savefile, "a") do |f|
          f.puts @smas
        end
      rescue IOError => e
      end
    end
  end

  class GetSubstring
    def initialize ss
      @ss = ss
    end
      def getSub
      index = @ss.index('media/remote_server/')
      if @ss.rindex(".js")
        indexjs = @ss.index('.js')
        substr = @ss[index + 20..indexjs + 3]
        stf = StringToFile.new(substr)
        stf.writeFile
      end
      if @ss.rindex(".php")
        indexphp = @ss.index('.php') 
        substr = @ss[index + 20..indexphp + 4]
        stf = StringToFile.new(substr)
        stf.writeFile
      end
    end   
  end

  class ParseDiff
    def pDiff 
      rs = ReadSettings.new
      rs.getSettings
      file = File.join(ENV['HOME'],rs.options["diff_file"])
      if File.exists? file
        pfile = File.open(file)
        pfile.each {|line|
          if line.rindex(".js")
            gs = GetSubstring.new(line)
            gs.getSub
          # puts "Тревога строка #{line.gsub}. содержит js"
          end
          if line.rindex(".php")
          # puts "Тревога строка #{line} содержит php"
            gs = GetSubstring.new(line)
            gs.getSub
          end  
        } 
      else
        STDERR.puts "File dues not exists #{file}"
      end
    end 
  end

  class SendMail
    require 'net/smtp'
    require 'rubygems'
    require 'mailfactory'
    def initialize (where_mail, my_mail, my_mail_login, my_mail_password, save_file)
      @where_mail = where_mail
      @my_mail = my_mail
      @my_mail_login = my_mail_login
      @my_mail_password = my_mail_password
      @save_file = save_file
    end 
    def sendMail
      mail = MailFactory.new()
      mail.to = "novzraion@yandex.ru"
      mail.from = "ter.novzraion@yandex.ru"
      mail.subject = "Сообщение для Андрея Владимировича. Сайт."
      mail.text = "Внимание с файлами на сервере произошли изменения. Сообщите об этом письме Андрею Владимировичу."
      filename = File.join(ENV['HOME'],"#{@save_file}")
      
      if File.file?(filename) then
        puts "File exists"
      else
        puts "All ok."
        exit(0)
      end

      mail.attach("#{filename}")

      # Let's put our code in safe area
      begin  
        smtp = Net::SMTP.new( "smtp.yandex.ru", 25)
        smtp.enable_starttls
        smtp.start('yandex.ru', "#{@my_mail_login}", "#{@my_mail_password}", :plain) do |conn|
        conn.send_message mail.to_s(), "#{@my_mail}", ["#{@where_mail}"]
        puts "Mail was send"
        end
      rescue Exception => e
        print e.message
      end
    end
  end

  del = DelOutFile.new
  del.delOutFile
  run = ParseDiff.new
  run.pDiff
  gs = ReadSettings.new
  gs.getSettings
  sm = SendMail.new(gs.options["where_mail"], gs.options["my_mail"], gs.options["my_mail_login"], gs.options["my_mail_password"], gs.options["save_file"])
  sm.sendMail
end
