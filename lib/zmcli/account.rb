module Zmcli
  class Account
    def initialize(account = nil)
      @account = account
    end
    def get_list_of_all_accounts
      stdin, stdout, stderr = Open3.popen3("/opt/zimbra/bin/zmprov -l gaa")
      stdout.read.split("\n")
    end
    def reindex_account
      puts   "Reindexing #{@account}"
      system("/opt/zimbra/bin/zmprov rim #{@account} start")
      puts "Finished Reindexing of #{@account}"
    end
    def backup_account_to_current_directory
      after_string = '"' + "/?fmt=tgz" + '"'
      system("/opt/zimbra/bin/zmmailbox -z -m #{@account} getRestURL #{after_string} > #{@account}.tar.gz")
    end
  end
end
