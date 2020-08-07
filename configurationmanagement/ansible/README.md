# Automation with Ansible

Ansible ist ein pushbasiertes Konfigurationsmanagementtool.

In Ansible gibt es drei verschiedenen Optionen

* Ansible installieren und einfach Playbooks schreiben
* Ansible installieren und geschriebene Playbooks mittels Ansible-Galaxy in Rollen gruppieren
* Ansible und Ansible-Tower installieren (wird nicht beschrieben da es eine Bezahlversion ist)


## Install Ansible
Ansible kann über die install.sh Datei installiert werden

## GalaxyStruktur initialiseren
ansible-galaxy init {rolename}

------------------------------------------------------------------------

## Bedigungen
Ansible can auf jeder Maschine mit Python 2.7 oder Python 3.5 + ausgeführt werden.

------------------------------------------------------------------------

## Nodes registrieren
Die zu verwaltenden Nodes werden in der Datei /etc/ansible/hosts
verwaltet, es können entweder direkte IPs angegeben werden oder
Hostnamen und FQDNs (Fully Qualified Domain Names). Nodes können
optional zu Gruppen zusammengefasst werden, des weiteren können auch
Benutzernamen angegeben werden.

/etc/ansible/hosts
------------------------------------------------------------------------
### Allgemein:
[gruppenname] #optional
clientdomain <ansible_user=clientuser> #auch mit regex

#### Bsp:
[dbclients]
client2.local ansible_user=client2


### Einrichtung Windows Node
Auf Windows wird WinRM für die Remoteverwaltung verwendet. Für WinRM
muss zuerst in den Systemeinstellungen die Firewall so konfiguriert
werden, dass sie die Verbindung zulässt, anschließend wird ein von
Ansible bereitgestelltes PowerShell-Skript für den weiteren Setup
verwendet.

Systemeinstellungen > Windows Firewall > Apps über Firewall
kommunizieren lassen > Windows-Remoteverwaltung

PowerShell (als Administrator):
>$url = "https://raw.githubusercontent.com/ansible/ansible/devel
/examples/scripts/ConfigureRemotingForAnsible.ps1"
>$file = "$env:temp\ConfigureRemotingForAnsible.ps1"
>(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
>powershell.exe -ExecutionPolicy ByPass -File $file

# Run Galaxy role
It is possible to run against the role with this command:

ansible localhost -m include_role -a name={rolename}

It is also possible to define a playbook and then add the role in the playbook

# Run Playbook
ansible-playbook $playbook$.yaml -i $inventory$.yaml


# Ansible pull
Go to this repo to see example ansible pulling https://github.com/Kreidl/ansible-pull
