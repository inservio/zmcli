module Zmcli

  ZMPROV = '/opt/zimbra/bin/zmprov'

  class Account
    def initialize(account = nil)
      @account = account
    end
    def list_all
      stdout, status = Open3.capture2(ZMPROV, '-l', 'gaa')
      stdout.read.split("\n")
    end
    def reindex
      puts   "Reindexing #{@account}"
      system(ZMPROV, 'rim', @account, 'start')
      puts "Finished Reindexing of #{@account}"
    end
    def backup
      puts "Backing up #{@account}"
      after_string = '"' + "/?fmt=tgz" + '"'
      system(ZMPROV, '-z', '-m', @account, 'getRestURL', after_string, '>', "#{@account}.tar.gz")
    end
    def restore
      puts "Restoring #{@account}"
      after_string = '"' + "/?fmt=tgz&resolve=skip" + '"'
      system(ZMPROV, '-z', '-m', @account, 'postRestURL', after_string, "#{@account}.tar.gz")
    end
    def backup_last_month
      last_month = Time.now.to_date.prev_month.strftime '%m/%d/%Y'
      after_string = '"' + "//?fmt=tgz&query=after:#{last_month}" + '"'
      puts "Backing up last month of #{@account}"
      system(ZMPROV, '-z', '-m', @account, 'getRestURL', after_string, '>', "#{@account}.tar.gz")
    end
  end
end
