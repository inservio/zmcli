require_relative 'defaults.rb'

module Zmcli
  class Domain
    def initialize(domain)
      @domain = domain
    end
    def list_all_accounts
      stout, status = Open3.capture2("#{ZMPATH}zmprov", '-l', 'ga', @domain)
      stdout.read.split("\n")
    end
  end
end
