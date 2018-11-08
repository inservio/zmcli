# Zmcli

Zimbra CLI automation tool.


## Usage examples.

### Reindex

**Reindex all accounts**
````
zmcli.rb --reindex=all
````
**Reindex a single account**

````
zmcli.rb --reindex=email@domain.tld
````

### Backup

**Backup a single account**

````
zmcli.rb --backup-account=email@domain.tld
````

**Backup a single account for period of last month**

````
zmcli.rb --backup-last-month-account=email@domain.tld
````

**Backup all accounts for a domain**

````
zmcli.rb --backup-accounts-for-domain=domain.tld
````

### Increase Mail Quota

````
zmcli.rb --increase-mail-quota-for-account=email@domain.tld
````

````
zmcli.rb --increase-mail-quota-for-all-domain-accounts=domain.tld
````
