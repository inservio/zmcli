module Zmcli
  class Account
    def initialize(account = nil)
      @account = account
    end
    def get_list_of_all_accounts
      accounts = []
      stdin, stdout, stderr = Open3.popen3("/opt/zimbra/bin/zmprov -l gaa")
      gada = stdout.read
      accounts = gada.split("\n")
      return accounts
    end
  end
end
