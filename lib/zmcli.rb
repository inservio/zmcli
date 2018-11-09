require 'optparse'
require 'open3'
require 'date'
#
require_relative 'zmcli/admin.rb'
require_relative 'zmcli/domain.rb'
require_relative 'zmcli/account.rb'
require_relative 'zmcli/quota.rb'

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
        Account.new(a).reindex_account
      end
    else
      if options[:reindex]
        Account.new(options[:reindex]).reindex_account
      end
    end

    if options[:blma]
      Account.new(options[:blma]).backup_account_last_month_to_current_directory
    end

    if options[:backup_account]
      Account.new(options[:backup_account]).backup_account_to_current_directory
    end

    if options[:bafd]
      accounts = []
      accounts = Domain.new(options[:bafd]).get_list_of_accounts_for_domain
      accounts.each do |a|
        Account.new(a).backup_account_to_current_directory
      end
    end

    if options[:imqfa]
      current_mail_quota = Quota.new(options[:imqfa]).get_quota_usage_for_account
      new_mail_quota = current_mail_quota.to_i + 943718400
      puts "Current mail quota is:"
      Quota.new(options[:imqfa]).get_current_mail_quota
      Quota.new(options[:imqfa], new_mail_quota).get_current_mail_quota
      puts "New mail quota is:"
      Quota.new(options[:imqfa]).get_current_mail_quota
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
        Quota.new(a).get_current_mail_quota
        system("/opt/zimbra/bin/zmprov ma #{a} zimbraMailQuota #{new_mail_quota.to_i}")
        puts "New mail quota is:"
        Quota.new(a).get_current_mail_quota
      end
    end

    if options[:makeadmin_account] && options[:makeadmin_domain]
      MakeAdmin.new(options[:makeadmin_account],options[:makeadmin_domain])
    end

  end
end
