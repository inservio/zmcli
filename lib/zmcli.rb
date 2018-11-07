#require "zmcli/version"
require 'optparse'
require 'open3'
require 'date'

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
      opt.on '--increase-mail-quota-for-account Account', 'Increase mail quota for account' do |arg|
        options[:imqfa] = arg
      end
      opt.on '--make-admin ACCOUNT, DOMAIN', 'Backup account for period of last month' do |arg|
        options[:makeadmin_account] = arg[0]
        options[:makeadmin_domain] = arg[0]
      end
    end

    opt_parser.parse!

    if options[:reindex] == "all"
      accounts = []
      stdin, stdout, stderr = Open3.popen3("/opt/zimbra/bin/zmprov -l gaa")
      gaa = stdout.read
      accounts = gaa.split("\n")
      accounts.each do |a|
        puts "Reindexing #{a}"
        system("/opt/zimbra/bin/zmprov rim #{a} start")
        puts "Finished Reindexing of #{a}"
      end
    else
      if options[:reindex]
        puts   "Reindexing #{options[:reindex]}"
        system "/opt/zimbra/bin/zmprov rim #{options[:reindex]} start"
        puts "Finished Reindexing of #{options[:reindex]}"
      end
    end

    if options[:blma]
      LastMonth = Time.now.to_date.prev_month.strftime '%m/%d/%Y'
      puts "Backing up #{options[:blma]}"
      AfterString = '"' + "//?fmt=tgz&query=after:#{LastMonth}" + '"'
      system("/opt/zimbra/bin/zmmailbox -z -m #{options[:blma]} getRestURL #{AfterString} > #{options[:blma]}.tar.gz")
    end

    if options[:backup_account]
      puts "Backing up #{options[:backup_account]}"
      BackupAccountAfterString = '"' + "/?fmt=tgz" + '"'
      system("/opt/zimbra/bin/zmmailbox -z -m #{options[:backup_account]} getRestURL #{BackupAccountAfterString} > #{options[:backup_account]}.tar.gz")
    end

    if options[:bafd]
      accounts = []
      BAFDAfterString = '"' + "/?fmt=tgz" + '"'
      stdin, stdout, stderr = Open3.popen3("/opt/zimbra/bin/zmprov -l gaa #{options[:bafd]}")
      gaa = stdout.read
      accounts = gaa.split("\n")
      accounts.each do |a|
        puts "Backing up account #{a}"
        system("/opt/zimbra/bin/zmmailbox -z -m #{a} getRestURL #{BAFDAfterString} > #{a}.tar.gz")
      end
    end

    if options[:imqfa]
      CutString = 'cut -d " " -f3'
      stdin, stdout, stderr = Open3.popen3("zmprov gqu $(zmhostname) | grep -w #{options[:imqfa]} | #{CutString} | head -n 1")
      current_mail_quota = stdout.read
      new_mail_quota = current_mail_quota.to_i + 100000000
      puts "Increasing mail quota for account #{options[:imqfa]}"
      system("/opt/zimbra/bin/zmprov ma #{options[:imqfa]} zimbraMailQuota #{new_mail_quota.to_i}")
    end

    if options[:makeadmin_account] && options[:makeadmin_domain]
      system("zmprov ma #{options[:makeadmin_account]} zimbraIsDelegatedAdminAccount TRUE")
      system("zmprov ma #{options[:makeadmin_account]} zimbraAdminConsoleUIComponents cartBlancheUI zimbraAdminConsoleUIComponents domainListView zimbraAdminConsoleUIComponents accountListView zimbraAdminConsoleUIComponents DLListView")
      system("zmprov ma #{options[:makeadmin_account]} zimbraDomainAdminMaxMailQuota 0")
      system("zmprov grantRight domain #{options[:makeadmin_domain]} usr #{options[:makeadmin_account]} +createAccount")
      system("zmprov grantRight domain #{options[:makeadmin_domain]} usr #{options[:makeadmin_account]} +createAlias")
      system("zmprov grantRight domain #{options[:makeadmin_domain]} usr #{options[:makeadmin_account]} +createCalendarResource")
      system("zmprov grantRight domain #{options[:makeadmin_domain]} usr #{options[:makeadmin_account]} +createDistributionList")
      system("zmprov grantRight domain #{options[:makeadmin_domain]} usr #{options[:makeadmin_account]} +deleteAlias")
      system("zmprov grantRight domain #{options[:makeadmin_domain]} usr #{options[:makeadmin_account]} +listDomain")
      system("zmprov grantRight domain #{options[:makeadmin_domain]} usr #{options[:makeadmin_account]} +domainAdminRights")
      system("zmprov grantRight domain #{options[:makeadmin_domain]} usr #{options[:makeadmin_account]} +configureQuota")
      system("zmprov grantRight domain #{options[:makeadmin_domain]} usr #{options[:makeadmin_account]} set.account.zimbraAccountStatus")
      system("zmprov grantRight domain #{options[:makeadmin_domain]} usr #{options[:makeadmin_account]} set.account.sn")
      system("zmprov grantRight domain #{options[:makeadmin_domain]} usr #{options[:makeadmin_account]} set.account.displayName")
      system("zmprov grantRight domain #{options[:makeadmin_domain]} usr #{options[:makeadmin_account]} set.account.zimbraPasswordMustChange")
      system("zmprov grantRight account #{options[:makeadmin_account]} usr #{options[:makeadmin_account]} +deleteAccount")
      system("zmprov grantRight account #{options[:makeadmin_account]} usr #{options[:makeadmin_account]} +getAccountInfo")
      system("zmprov grantRight account #{options[:makeadmin_account]} usr #{options[:makeadmin_account]} +getAccountMembership")
      system("zmprov grantRight account #{options[:makeadmin_account]} usr #{options[:makeadmin_account]} +getMailboxInfo")
      system("zmprov grantRight account #{options[:makeadmin_account]} usr #{options[:makeadmin_account]} +listAccount")
      system("zmprov grantRight account #{options[:makeadmin_account]} usr #{options[:makeadmin_account]} +removeAccountAlias")
      system("zmprov grantRight account #{options[:makeadmin_account]} usr #{options[:makeadmin_account]} +renameAccount")
      system("zmprov grantRight account #{options[:makeadmin_account]} usr #{options[:makeadmin_account]} +setAccountPassword")
      system("zmprov grantRight account #{options[:makeadmin_account]} usr #{options[:makeadmin_account]} +viewAccountAdminUI")
      system("zmprov grantRight account #{options[:makeadmin_account]} usr #{options[:makeadmin_account]} +configureQuota")
    end

  end
end
