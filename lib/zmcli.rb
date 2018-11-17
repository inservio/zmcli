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
      opt.on '--backup ACCOUNT', 'Backup account.' do |arg|
        options[:backup_account] = arg
      end
      opt.on '--backup-accounts-for-domain DOMAIN', 'Backup account for period of last month' do |arg|
        options[:bafd] = arg
      end
      opt.on '--restore ACCOUNT', 'Restore account.' do |arg|
        options[:restore_account] = arg
      end
      opt.on '--increase-mail-quota-for-account ACCOUNT', 'Increase mail quota for account' do |arg|
        options[:imqfa] = arg
      end
      opt.on '--increase-mail-quota-for-all-domain-accounts DOMAIN', 'Increase mail quota for all accounts under a domain.' do |arg|
        options[:imqfada_domain] = arg
      end
      opt.on '--make-admin ACCOUNT, DOMAIN', 'Backup account for period of last month' do |arg|
        options[:makeadmin_account] = arg[0]
        options[:makeadmin_domain] = arg[1]
      end
    end

    opt_parser.parse!

    # Reindex All Acounts
    if options[:reindex] == "all"
      accounts = []
      accounts = Account.new().list_all
      accounts.each do |a|
        account = Account.new(a)
        account.reindex
      end
    else
      # Reindex a single account
      if options[:reindex]
        account = Account.new(options[:reindex])
        account.reindex
      end
    end

    # Backup Last Month for all Accounts
    if options[:blma] == "all"
      accounts = []
      accounts = Account.new().list_all
      accounts.each do |a|
        account = Account.new(a)
        account.backup_last_month
      end
    else
      if options[:blma]
        account = Account.new(options[:blma])
        account.backup_last_month
      end
    end

    # Backup Complete Account
    if options[:backup_account]
      account = Account.new(options[:backup_account])
      account.backup
    end

    # Backup Accounts For Domain
    if options[:bafd]
      accounts = []
      domain = Domain.new(options[:bafd])
      accounts = domain.list_all_accounts
      accounts.each do |a|
        account = Account.new(a)
        account.backup
      end
    end

    # Restore Complete Account
    if options[:restore_account]
      account = Account.new(options[:restore_account])
      account.restore
    end

    # Increase Mail Quota For Account
    if options[:imqfa]
      current_mail_quota = Quota.new(options[:imqfa]).get_quota_usage_for_account
      new_mail_quota = current_mail_quota.to_i + 943718400
      puts "Current mail quota is:"
      Quota.new(options[:imqfa]).get_current_mail_quota
      Quota.new(options[:imqfa], new_mail_quota).get_current_mail_quota
      puts "New mail quota is:"
      Quota.new(options[:imqfa]).get_current_mail_quota
    end

    # Increase Mail Quota For All Domain Accounts
    if options[:imqfada_domain]
      accounts = []
      domain = Domain.new(options[:imqfada_domain])
      accounts = domain.list_all_accounts
      accounts.each do |a|
        account = Quota.new(a)
        account.get_current_mail_quota
        new_mail_quota = current_mail_quota.to_i + 943718400
        puts "Increasing mail quota for account #{a}"
        puts "Current mail quota is:"
        account.get_current_mail_quota
        Quota.new(a, new_mail_quota).get_current_mail_quota
        puts "New mail quota is:"
        account.get_current_mail_quota
      end
    end

    # Grant Admin Privileges for a Domain
    if options[:makeadmin_account] && options[:makeadmin_domain]
      MakeAdmin.new(options[:makeadmin_account],options[:makeadmin_domain])
    end

  end
end
