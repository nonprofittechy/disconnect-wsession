<#
	Disconnect all logged-in sessions for the given username, for all servers in the OU provided in the variable $baseOU
	Will prompt for username but default to the current user.
	Also will default to OU of current PC unless the OU to run script against is specified.
	Quinten Steenhuis, 9/20/2016
#>


# uncomment the following and set to the correct OU if you don't want to default to the OU of the current computer running the script
#$baseOU = "ou=servers,dc=domain,dc=local"

import-module .\disconnect-wsession.psm1

$thisPC = $env:computername
$thisPCDN = (get-adcomputer $thisPC).distinguishedName

# set default OU to run on to the OU of the current PC, unless specified above. See: https://www.akaplan.com/blog/2015/09/get-the-parent-ou-for-an-ad-object/
$baseOU = if ($baseOU) {$baseOU} else {(([adsi]"LDAP://$($thisPCDN)").Parent).Substring(7)}

[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
$username = [Microsoft.VisualBasic.Interaction]::InputBox("Enter the username to disconnect. `r`nThis user will be logged off of all machines in the OU " + $baseOU, "Username", "$env:username") 

$servers = get-adcomputer -searchbase $baseOU -filter {name -ne $thisPC}

foreach ($server in $servers) {
	#write-host $server.name
	disconnect-wsession -computer $server.name -username $username
}