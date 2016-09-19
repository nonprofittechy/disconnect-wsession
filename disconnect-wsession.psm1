<#
 Disconnect-wsession: forefully logoff a user's session using the qwinsta.exe / rwinsta.exe commands
 Purpose: prevent automatic account lockout
 Defaults to logging off the current user's session on the remote computer.
 
 #>
function disconnect-wsession ($computer, $username) {
	$username = if ($username) {$username} else {$env:username}

	if (test-connection $computer -count 1) {
    
        $sessions = get-wsessions $computer 

		foreach ($result in $sessions) {
			if ($result.userName -like $username){
							rwinsta /server:$computer $result.id
			}
		}
	} 
}

function get-wsessions($computer) {
	$sessions = qwinsta /server:$computer
	$sessions = $sessions[1..$($sessions.Count - 1)]
	$rsessions = @()
	
	foreach ($Result in $sessions) {
		
		$userName = $Result.Substring(19,22).Trim()
		$id = $Result.Substring(41,7).Trim()                         
		$r = @{
				"username" = $username;
				"id" = $id
				}
		$rsessions += new-object psobject -property $r
	}   
	
	return $rsessions
}