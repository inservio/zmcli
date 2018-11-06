#require "zmcli/version"
require 'optparse'
require 'open3'

module Zmcli
  class Reindex
    options = {}

    opt_parser = OptionParser.new do |opt|
      opt.banner = "Usage: COMMAND [OPTIONS]"

      opt.on '--reindex all', 'Reindex all accounts' do |arg|
        accounts = []
        stdin, stdout, stderr = Open3.popen3("/opt/zimbra/bin/zmprov -l gaa")
        gaa = stdout.read
        accounts = gaa.split("\n")
        accounts.each do |a|
          puts "Reindexing #{a}"
          system("/opt/zimbra/bin/zmprov rim #{a} start")
          puts "Finished Reindexing of #{a}"
        end
      end

      opt.on '--reindex', 'Reindex a single account' do |arg|
        puts   "Reindexing #{arg}"
        system "/opt/zimbra/bin/zmprov rim #{arg} start"
        puts   "Finished Reindexing of #{arg}"
      end

  end
  opt_parser.parse!
end
end
