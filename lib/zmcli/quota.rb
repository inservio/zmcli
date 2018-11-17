require_relative 'defaults.rb'

module Zmcli
  class Quota
    def initialize(account = nil, quota = 0)
      @account = account
      @quota = quota
    end
    def get_quota_usage_for_account
      cut_string = 'cut -d " " -f3'
      stdout, status = Open3.capture2("zmprov gqu $(zmhostname) | grep -w #{@account} | #{cut_string} | head -n 1")
      stdout
    end
    def get_current_mail_quota
      system("#{ZMPATH}zmprov", 'ga', @account, 'zimbraMailQuota')
    end
    def set_mail_quota
      puts "Increasing mail quota for account #{@account}"
      system("#{ZMPATH}zmprov", 'ma', @account, 'zimbraMailQuota', @quota.to_i)
    end
  end
end
