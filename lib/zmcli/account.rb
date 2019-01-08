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
      system("#{ZMPATH}zmmailbox", '-z', '-m', @account, 'getRestURL', '-o', "#{@account}.tar.gz", "//?fmt=tgz")
    end
    def restore
      puts "Restoring #{@account}"
      system("#{ZMPATH}zmmailbox", '-z', '-m', @account, 'postRestURL', '-o', "#{@account}.tar.gz", "//?fmt=tgz&resolve=skip")
    end
    def backup_last_month
      last_month = Time.now.to_date.prev_month.strftime '%m/%d/%Y'
      after_string = "//?fmt=tgz&query=after:#{last_month}"
      puts "Backing up last month of #{@account}"
      system("#{ZMPATH}zmmailbox", '-z', '-m', @account, 'getRestURL', '-o', "#{@account}.tar.gz", after_string)
    end
  end
end
