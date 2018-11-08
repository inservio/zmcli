require 'optparse'
require 'open3'
require 'date'
#
require_relative 'zmcli/admin.rb'
require_relative 'zmcli/domain.rb'
require_relative 'zmcli/account.rb'

module Zmcli
  class Main
    options = {}

    opt_parser = OptionParser.new do |opt|
      opt.banner = "Usage: COMMAND [OPTIONS]"

      opt.on '--reindex ACCOUNT', 'Reindex accounts' do |arg|
        options[:reindex] = arg
      end
      opt.on '--backup-last-month-account ACCOUNT', 'Backup account for period of last month' do |arg|
        options[:blma] = arg
      end
      opt.on '--backup-account ACCOUNT', 'Backup account for period of last month' do |arg|
        options[:backup_account] = arg
      end
      opt.on '--backup-accounts-for-domain DOMAIN', 'Backup account for period of last month' do |arg|
        options[:bafd] = arg
      end
      opt.on '--increase-mail-quota-for-account ACCOUNT', 'Increase mail quota for account' do |arg|
        options[:imqfa] = arg
      end
      opt.on '--increase-mail-quota-for-all-domain-accounts DOMAIN', 'Increase mail quota for all accounts under a domain.' do |arg|
        options[:imqfada_domain] = arg
      end
      opt.on '--make-admin ACCOUNT, DOMAIN', 'Backup account for period of last month' do |arg|
        options[:makeadmin_account] = arg[0]
        options[:makeadmin_domain] = arg[0]
      end
    end

    opt_parser.parse!

    if options[:reindex] == "all"
      accounts = []
      accounts = Account.new().get_list_of_all_accounts
      accounts.each do |a|
        reindex_account(a)
      end
    else
      if options[:reindex]
        reindex_account(options[:reindex])
      end
    end

    def self.reindex_account(account)
      puts   "Reindexing #{account}"
      system("/opt/zimbra/bin/zmprov rim #{account} start")
      puts "Finished Reindexing of #{account}"
    end

    if options[:blma]
      last_month = Time.now.to_date.prev_month.strftime '%m/%d/%Y'
      puts "Backing up #{options[:blma]}"
      after_string = '"' + "//?fmt=tgz&query=after:#{last_month}" + '"'
      system("/opt/zimbra/bin/zmmailbox -z -m #{options[:blma]} getRestURL #{after_string} > #{options[:blma]}.tar.gz")
    end

    if options[:backup_account]
      puts "Backing up #{options[:backup_account]}"
      backup_account_to_current_directory(options[:backup_account])
    end

    if options[:bafd]
      accounts = []
      stdin, stdout, stderr = Open3.popen3("/opt/zimbra/bin/zmprov -l gaa #{options[:bafd]}")
      gaa = stdout.read
      accounts = gaa.split("\n")
      accounts.each do |a|
        puts "Backing up account #{a}"
        backup_account_to_current_directory(a)
      end
    end

    if options[:imqfa]
      current_mail_quota = get_quota_usage_for_account(options[:imqfa])
      new_mail_quota = current_mail_quota.to_i + 943718400
      puts "Current mail quota is:"
      get_current_mail_quota(options[:imqfa])
      puts "Increasing mail quota for account #{options[:imqfa]}"
      system("/opt/zimbra/bin/zmprov ma #{options[:imqfa]} zimbraMailQuota #{new_mail_quota.to_i}")
      puts "New mail quota is:"
      get_current_mail_quota(options[:imqfa])
    end

    def self.get_quota_usage_for_account(account)
      cut_string = 'cut -d " " -f3'
      stdin, stdout, stderr = Open3.popen3("zmprov gqu $(zmhostname) | grep -w #{account} | #{cut_string} | head -n 1")
      current_mail_quota = stdout.read
      return current_mail_quota
    end

    def self.get_current_mail_quota(account)
      system("zmprov ga #{account} zimbraMailQuota")
    end

    def self.backup_account_to_current_directory(account)
      after_string = '"' + "/?fmt=tgz" + '"'
      system("/opt/zimbra/bin/zmmailbox -z -m #{a} getRestURL #{after_string} > #{a}.tar.gz")
    end

    if options[:imqfada_domain]
      accounts = []
      gada_cut_string = 'cut -d " " -f3'
      accounts = Domain.new(options[:imqfada_domain]).get_list_of_accounts_for_domain
      accounts.each do |a|
        stdin, stdout, stderr = Open3.popen3("zmprov gqu $(zmhostname) | grep -w #{a} | #{gada_cut_string} | head -n 1")
        current_mail_quota = stdout.read
        new_mail_quota = current_mail_quota.to_i + 943718400
        puts "Increasing mail quota for account #{a}"
        puts "Current mail quota is:"
        get_current_mail_quota(a)
        system("/opt/zimbra/bin/zmprov ma #{a} zimbraMailQuota #{new_mail_quota.to_i}")
        puts "New mail quota is:"
        get_current_mail_quota(a)
      end
    end

    if options[:makeadmin_account] && options[:makeadmin_domain]
      MakeAdmin.new(options[:makeadmin_account],options[:makeadmin_domain])
    end

  end
end
