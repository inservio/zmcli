module Zmcli
  class Account
    def initialize(account = nil)
      @account = account
    end
    def get_list_of_all_accounts
      stdin, stdout, stderr = Open3.popen3("/opt/zimbra/bin/zmprov -l gaa")
      stdout.read.split("\n")
    end
  end
end
