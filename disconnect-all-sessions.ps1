<#
	Disconnect all logged-in sessions for the given username, for all servers in the OU provided in the variable $baseOU
	Will prompt for username but default to the current user
#>

$baseOU = "ou=servers,dc=gbls,dc=local"

import-module .\disconnect-wsession.psm1

[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
$username = [Microsoft.VisualBasic.Interaction]::InputBox("Enter the username to disconnect. `r`nThis user will be logged off of all machines in the OU " + $baseOU, "Username", "$env:username") 
$thisPC = $env:computername
$servers = get-adcomputer -searchbase $baseOU -filter {name -ne $thisPC}

foreach ($server in $servers) {
	#write-host $server.name
	disconnect-wsession -computer $server.name -username $username
}