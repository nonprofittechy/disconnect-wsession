We have periodic password changes in our environment, which sometimes can cause account lockouts if the user has many open (or disconnected and not logged off) remote desktop sessions.

There are various native tools in Powershell that help with logging a user off of a single remote desktop session, but they are buggy or limited. In the end the old qwinst/rwinsta commands seemed to work more reliably for me to enumerate remote sessions and log a user off. 

Despite needing this functionality myself a few times, I looked around and I couldn't find a solution that put everything together. I wrote a simple script that will run against a domain and log a user off of all of the servers in that domain. I've cleaned up the code from [this script](http://hamidshahid.blogspot.com/2014/04/powershell-log-off-all-remote-sessions.html) a bit and made it more plug-and-play to enumerate all servers in a specific OU, prompt for a specific user, and log that one user off of all of the servers in the OU.

It does a quick ping test before attempting to enumerate sessions, but otherwise there is no error checking. Just quick and dirty.

The script is composed of two files: a simple powershell module with two commands, disconnect-wsession and get-wsession. The second file is the action script. To get it to work in your environment, edit disconnect-all-sessions.ps1 to point to the OU where your servers are located, and run the script on a machine with the AD Powershell modules installed.

The script defaults to logging off the current user and will exclude the current machine from the forced logoff.