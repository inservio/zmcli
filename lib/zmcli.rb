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
          #puts "zmprov rim #{a} start >/dev/null"
          puts "zmprov rim #{a} start"
        end
      end
    end
    opt_parser.parse!
  end
end
