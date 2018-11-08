module Zmcli
  class MakeAdmin
    def initialize(account,email)
      @account = account
      @domain = domain
    end
    system("zmprov ma #{@account} zimbraIsDelegatedAdminAccount TRUE")
    system("zmprov ma #{@account} zimbraAdminConsoleUIComponents cartBlancheUI zimbraAdminConsoleUIComponents domainListView zimbraAdminConsoleUIComponents accountListView zimbraAdminConsoleUIComponents DLListView")
    system("zmprov ma #{@account} zimbraDomainAdminMaxMailQuota 0")
    system("zmprov grantRight domain #{@domain} usr #{@account} +createAccount")
    system("zmprov grantRight domain #{@domain} usr #{@account} +createAlias")
    system("zmprov grantRight domain #{@domain} usr #{@account} +createCalendarResource")
    system("zmprov grantRight domain #{@domain} usr #{@account} +createDistributionList")
    system("zmprov grantRight domain #{@domain} usr #{@account} +deleteAlias")
    system("zmprov grantRight domain #{@domain} usr #{@account} +listDomain")
    system("zmprov grantRight domain #{@domain} usr #{@account} +domainAdminRights")
    system("zmprov grantRight domain #{@domain} usr #{@account} +configureQuota")
    system("zmprov grantRight domain #{@domain} usr #{@account} set.account.zimbraAccountStatus")
    system("zmprov grantRight domain #{@domain} usr #{@account} set.account.sn")
    system("zmprov grantRight domain #{@domain} usr #{@account} set.account.displayName")
    system("zmprov grantRight domain #{@domain} usr #{@account} set.account.zimbraPasswordMustChange")
    system("zmprov grantRight account #{@account} usr #{@account} +deleteAccount")
    system("zmprov grantRight account #{@account} usr #{@account} +getAccountInfo")
    system("zmprov grantRight account #{@account} usr #{@account} +getAccountMembership")
    system("zmprov grantRight account #{@account} usr #{@account} +getMailboxInfo")
    system("zmprov grantRight account #{@account} usr #{@account} +listAccount")
    system("zmprov grantRight account #{@account} usr #{@account} +removeAccountAlias")
    system("zmprov grantRight account #{@account} usr #{@account} +renameAccount")
    system("zmprov grantRight account #{@account} usr #{@account} +setAccountPassword")
    system("zmprov grantRight account #{@account} usr #{@account} +viewAccountAdminUI")
    system("zmprov grantRight account #{@account} usr #{@account} +configureQuota")
  end
end
