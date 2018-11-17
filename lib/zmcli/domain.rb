module Zmcli
  class Domain
    def initialize(domain)
      @domain = domain
    end
    def get_list_of_accounts
      stout, status = Open3.capture2("/opt/zimbra/bin/zmprov -l gaa", @domain)
      stdout.read.split("\n")
    end
  end
end
