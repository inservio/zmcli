require_relative 'defaults.rb'

module Zmcli
  class Account
    def initialize(account = nil)
      @account = account
    end
    def list_all
      stdout, status = Open3.capture2("#{ZMPATH}zmprov", '-l', 'gaa')
      stdout.split("\n")
    end
    def reindex
      puts   "Reindexing #{@account}"
      system("#{ZMPATH}zmprov", 'rim', @account, 'start')
      puts "Reindexing of #{@account} is finished"
    end
    def backup
      puts "Backing up #{@account}"
      after_string = '"' + "/?fmt=tgz" + '"'
      system("#{ZMPATH}zmprov", '-z', '-m', @account, 'getRestURL', after_string, '>', "#{@account}.tar.gz")
    end
    def restore
      puts "Restoring #{@account}"
      after_string = '"' + "/?fmt=tgz&resolve=skip" + '"'
      system("#{ZMPATH}zmprov", '-z', '-m', @account, 'postRestURL', after_string, "#{@account}.tar.gz")
    end
    def backup_last_month
      last_month = Time.now.to_date.prev_month.strftime '%m/%d/%Y'
      after_string = '"' + "//?fmt=tgz&query=after:#{last_month}" + '"'
      puts "Backing up last month of #{@account}"
      system("#{ZMPATH}zmprov", '-z', '-m', @account, 'getRestURL', after_string, '>', "#{@account}.tar.gz")
    end
  end
end
