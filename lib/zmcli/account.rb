module Zmcli
  class Account
    def initialize(account = nil)
      @account = account
    end
    def list_all
      stout, status = Open3.capture2("/opt/zimbra/bin/zmprov -l gaa")
      stdout.read.split("\n")
    end
    def reindex
      puts   "Reindexing #{@account}"
      system("/opt/zimbra/bin/zmprov rim #{@account} start")
      puts "Finished Reindexing of #{@account}"
    end
    def backup_to_current_directory
      puts "Backing up #{@account}"
      after_string = '"' + "/?fmt=tgz" + '"'
      system("/opt/zimbra/bin/zmmailbox -z -m #{@account} getRestURL #{after_string} > #{@account}.tar.gz")
    end
    def backup_last_month_to_current_directory
      last_month = Time.now.to_date.prev_month.strftime '%m/%d/%Y'
      after_string = '"' + "//?fmt=tgz&query=after:#{last_month}" + '"'
      puts "Backing up last month of #{@account}"
      system("/opt/zimbra/bin/zmmailbox -z -m #{@account} getRestURL #{after_string} > #{@account}.tar.gz")
    end
  end
end
