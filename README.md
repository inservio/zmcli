# Zmcli

Zimbra CLI automation tool.


## Usage examples.

### Reindex

**Reindex all accounts**

````
zmcli.rb reindex --account=all
````

````
zmcli.rb reindex -a=all
````

**Reindex a single account**

````
zmcli.rb reindex --account=email@domain.tld
````

### Backup

**Backup all accounts**

````
zmcli.rb backup --account=all
````

**Backup a single account**

````
zmcli.rb backup --account=email@domain.tld
````

**Backup a single account for specific period**

````
zmcli.rb backup-last --time=month --account=email@domain.tld
````

````
zmcli.rb backup-last --time=year --account=email@domain.tld
````

**Backup all accounts for a domain**

````
zmcli.rb backup-accounts --domain=domain.tld
````

### Increase Mail Quota

````
zmcli.rb increase-mail-quota --account=email@domain.tld
````

````
zmcli.rb increase-mail-quota-accounts --domain=domain.tld
````
