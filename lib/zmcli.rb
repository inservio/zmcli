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
      puts   "Reindexing #{options[:reindex]}"
      system "/opt/zimbra/bin/zmprov rim #{options[:reindex]} start"
      puts "Finished Reindexing of #{options[:reindex]}"
    end

    if options[:blma]
      LastMonth = Time.now.to_date.prev_month.strftime '%m/%d/%Y'
      puts "Backing up #{options[:blma]}"
      AfterString = '"' + "//?fmt=tgz&query=after:#{LastMonth}" + '"'
      system("/opt/zimbra/bin/zmmailbox -z -m #{options[:blma]} getRestURL #{AfterString} > #{options[:blma]}.tar.gz")
    else
      puts   "Account to backup not specified."
    end

  end
end
