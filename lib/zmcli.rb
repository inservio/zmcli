require 'open3'
require 'date'
#
require_relative 'zmcli/admin.rb'
require_relative 'zmcli/domain.rb'
require_relative 'zmcli/account.rb'
require_relative 'zmcli/quota.rb'

module Zmcli
  class Main

    cmd=ARGV.shift

    options = {}

    ARGV.each do |a|
      key, value = a.split("=")
      case key
      when "--domain", "-d"
        options[:domain]=value
      when "--account", "-a"
        options[:account]=value
      when "--time", "-t"
        case value
        when "month"
          options[:time]=Date.today-31
        when "year"
          options[:time]=Date.today-365
        end
      end
    end

    case cmd
    when "reindex"
      # Reindex All Acounts
      if options[:account] == "all"
        accounts = []
        accounts = Account.new().list_all
        accounts.each do |a|
          account = Account.new(a)
          account.reindex
        end
      else
        # Reindex a single account
        if options[:account]
          account = Account.new(options[:account])
          account.reindex
        end
      end
    when "backup-last"
      # Backup Last Month for all Accounts
      if options[:account] == "all"
        accounts = []
        accounts = Account.new().list_all
        accounts.each do |a|
          account = Account.new(a)
          account.backup_after(options[:time])
        end
      else
        if options[:account]
          account = Account.new(options[:account],options[:time])
          account.backup_after
        end
      end
    when "backup"
      # Comeplete Backup of all Accounts
      if options[:account] == "all"
        accounts = []
        accounts = Account.new().list_all
        accounts.each do |a|
          account = Account.new(a)
          account.backup
        end
      else
        # Complete Backup of an Account
        if options[:account]
          account = Account.new(options[:account])
          account.backup
        end
      end
    when "backup-accounts"
      # Backup all Accounts for a Domain
      if options[:domain]
        accounts = []
        domain = Domain.new(options[:domain])
        accounts = domain.list_all_accounts
        accounts.each do |a|
          account = Account.new(a)
          account.backup
        end
      end
    when "restore"
      # Restore Complete Account
      if options[:account]
        account = Account.new(options[:account])
        account.restore
      end
    when "increase-mail-quota"
      # Increase Mail Quota For Account
      if options[:account]
        current_mail_quota = Quota.new(options[:account]).get_quota_usage_for_account
        new_mail_quota = current_mail_quota.to_i + 943718400
        puts "Current mail quota is:"
        Quota.new(options[:account]).get_current_mail_quota
        Quota.new(options[:account], new_mail_quota).get_current_mail_quota
        puts "New mail quota is:"
        Quota.new(options[:account]).get_current_mail_quota
      end
    when "increase-mail-quota-accounts"
      # Increase Mail Quota For All Domain Accounts
      if options[:domain]
        accounts = []
        domain = Domain.new(options[:domain])
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
    when "make-admin"
      # Grant Admin Privileges for a Domain
      if options[:account] && options[:domain]
        admin = MakeAdmin.new(options[:account],options[:domain])
        admin.make_admin
      end
    end

  end
end
