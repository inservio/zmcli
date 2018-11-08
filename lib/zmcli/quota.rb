module Zmcli
  class Quota
    def initialize(account = nil)
      @account = account
    end
    def get_quota_usage_for_account
      cut_string = 'cut -d " " -f3'
      stdin, stdout, stderr = Open3.popen3("zmprov gqu $(zmhostname) | grep -w #{@account} | #{cut_string} | head -n 1")
      current_mail_quota = stdout.read
      return current_mail_quota
    end
    def get_current_mail_quota
      system("zmprov ga #{@account} zimbraMailQuota")
    end
  end
end
