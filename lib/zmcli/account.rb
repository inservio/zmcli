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
      if system("#{ZMPATH}zmprov", 'rim', @account, 'start')
        puts "Reindexing of #{@account}  was successful."
      else
        puts "Reindexing of #{@account} failed"
      end
    end
    def backup
      puts "Backing up #{@account}"
      if system("#{ZMPATH}zmmailbox", '-z', '-m', @account, 'getRestURL', '-o', "#{@account}.tar.gz", "//?fmt=tgz")
        puts "Backing up #{@account} was successful."
      else
        puts "Backing up #{@account}"
      end
    end
    def restore
      puts "Restoring #{@account}"
      if system("#{ZMPATH}zmmailbox", '-z', '-m', @account, 'postRestURL', '-o', "#{@account}.tar.gz", "//?fmt=tgz&resolve=skip")
        puts "Restore of #{@account} was successful."
      else
        puts "Restore of #{@account} failed."
      end
    end
    def backup_last_month
      last_month = Time.now.to_date.prev_month.strftime '%m/%d/%Y'
      puts "Starting last month backup of #{@account}."
      if system("#{ZMPATH}zmmailbox", '-z', '-m', @account, 'getRestURL', '-o', "#{@account}.tar.gz", "//?fmt=tgz&query=after:#{last_month}")
        puts "Backing up last month of #{@account} was successful."
      else
        puts "Backing up last month of #{@account} failed."
      end
    end
  end
end
