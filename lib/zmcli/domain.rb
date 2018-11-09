module Zmcli
  class Domain
    def initialize(domain)
      @domain = domain
    end
    def get_list_of_accounts_for_domain
      stdin, stdout, stderr = Open3.popen3("/opt/zimbra/bin/zmprov -l gaa", @domain)
      gada = stdout.read.split("\n")
    end
  end
end
