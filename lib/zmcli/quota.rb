module Zmcli
  class Quota
    def initialize(account = nil, quota = 0)
      @account = account
      @quota = quota
    end
    def get_quota_usage_for_account
      cut_string = 'cut -d " " -f3'
      stdin, stdout, stderr = Open3.popen3("zmprov gqu $(zmhostname) | grep -w #{@account} | #{cut_string} | head -n 1")
      stdout.read
    end
    def get_current_mail_quota
      system("zmprov ga #{@account} zimbraMailQuota")
    end
    def set_mail_quota
      puts "Increasing mail quota for account #{@account}"
      system("/opt/zimbra/bin/zmprov ma #{@account} zimbraMailQuota #{@quota.to_i}")
    end
  end
end
