module Zmcli
  class Domain
    def initialize(domain)
      @domain = domain
    end
    def get_list_of_accounts_for_domain
      stout, status = Open3.capture2("/opt/zimbra/bin/zmprov -l gaa", @domain)
      stdout.read.split("\n")
    end
  end
end
