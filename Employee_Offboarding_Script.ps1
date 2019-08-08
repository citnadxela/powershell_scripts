#  This is the offboarding 
#  script ran, usually imediately, 
#  by either Help Desk or 
#  Human Resources whenever an 
#  employee is terminated or 
#  has left the company.  


import-module activedirectory
import-module MSOnline
Import-Module AzureAD

$username = "username"
$password = Get-Content 'C:\Windows\powershellSession.txt' | ConvertTo-SecureString
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $password
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri URL -Authentication Kerberos -Credential $cred
Import-PSSession $Session

#  Have the helpdesk user login wi/ their credentials
$UserCredential = Get-Credential
Connect-MsolService -Credential $UserCredential
Connect-AzureAD -Credential $UserCredential

#  Connect to Okta.
$seckey = get-content C:\Windows\deactivateOkta.txt | ConvertTo-SecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($seckey)
$key = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
Import-Module OktaAPI
Connect-Okta $key "https://domain.okta.com"

do 
{
    $Firstname = Read-Host "`nWhat is the user's first name?"
    $Lastname = Read-Host "What is the user's last name?"
    $userAccount = (Get-ADUser -Filter "GivenName -like '$Firstname' -and Surname -like '$Lastname'").SamAccountName
    $o365Account = "$userAccount@llmhq.com"
    If ($userAccount -eq $Null) 
        {
            "`nUser does not exist." 
            "Stopping script.`n"
            exit
        }
    $userInfo = Get-ADUser -Filter * -Properties Emailaddress | Where-Object {$_.GivenName -like $Firstname -and $_.Surname -like $Lastname} | Select Name, SamAccountName, Emailaddress
    $userEmailAddress = $userInfo | select -ExpandProperty Emailaddress
    $userFullName = $userInfo | select -ExpandProperty Name
    Write-Host –NoNewLine "`nAre you sure you want to reset the following user's password & remove all group memberships?`n" 
    Write-Host –NoNewLine "`n$userInfo`n"
    $Readhost = Read-Host "`n( y / n ) " 
    Switch ($ReadHost) 
    { 
       Y {
            #  Resets the user's current password to a random generated, 15 character, password.
            $randomPassword = -join (33..126 | ForEach-Object {[char]$_} | Get-Random -Count 15)
            $randomPassword += "1Q!"
            $newPassword = ConvertTo-SecureString -String $randomPassword -AsPlainText –Force
            Set-ADAccountPassword -Identity $userAccount -NewPassword $newPassword –Reset 
            Write-Host "`nThe password was successfully reset. `n"

            #  Export all groups that user is a member of to Excel file.
            Get-ADPrincipalGroupMembership $userAccount | select name | Export-Csv -path "C:\Users\administrator\Desktop\Employee Termination\User Groups\${userAccount}.csv" -NoTypeInformation

            #  Remove all group memberships of user.
            Get-ADUser -Identity $userAccount -Properties MemberOf | ForEach-Object {$_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -Confirm:$false}

            #  Add user to  - Former Employees container.
            Add-ADGroupMember -Identity " - Journal and Former Employees - DELETE ALL EMAILS" -Members $userAccount

            #  Set the - Former Employees container as the Primary Group.
            $newPrimaryGroup = get-adgroup "- Journal and Former Employees - DELETE ALL EMAILS" -properties @("primaryGroupToken")
            get-aduser $userAccount | set-aduser -replace @{primaryGroupID=$newPrimaryGroup.primaryGroupToken}

            #  Remove the user from the Domain Users group.
            Remove-ADGroupMember -Identity "Domain Users" -Members $userAccount -Confirm:$false

            Write-Host –NoNewLine "`nWill emails be forwarded to their manager?`n"
            $forwarded = Read-Host "`n( y / n ) " 
            Switch ($forwarded)
            {
                Y 
                   {
                   
                        do{
                            #  Prompt who the manager of the user being terminated is.
                            $managersAccount = Read-Host "`nWhat is the manager's account"
                        }while (!$managersAccount.Contains("domain.com"))

                        #  Add '123' to terminated user's SMTP address.
                        $addOn = '123'
                        $mailparts = $userEmailAddress.Split('@')
                        $newemail = "$($mailparts[0])$($addOn)@$($mailparts[1])"
                        Set-RemoteMailbox -Identity $userAccount -PrimarySmtpAddress $newemail

                        #  Remove the previous SMTP address from the user's e-mail address list so that it can be added to their manager's.
                        Get-RemoteMailbox -Identity $userAccount | Set-RemoteMailbox -EmailAddresses @{remove=$userEmailAddress}

                        #  Add terminated user's e-mail address to manager's e-mail address list.
                        Set-RemoteMailbox $managersAccount -EmailAddresses @{add=$userEmailAddress}

                   }
                N
                   {
                        break
                   }
                
            }

			#  Hide the user's mailbox on office 365
			Set-ADUser $userAccount -REPLACE @{msExchHideFromAddressLists="TRUE"}

            #  Add user description property wi/ the date the user has to be deleted by (90 days from termination date).
            $deleteByDate = Get-Date (Get-Date).adddays(90) -format D
            get-aduser $userAccount | set-aduser -replace @{description="Delete by ${deleteByDate}"}


            #  Sync Azure AD.
            Write-Host "Azure sync: `n"
            $test = Invoke-Command -ComputerName hq-azuresync -ScriptBlock { Start-ADSyncSyncCycle -PolicyType Delta }
            if (!$test)
            {
                Write-Host "Waiting 1 min. before manually syncing Azure AD. `n"
                Start-Sleep -s 60
                Invoke-Command -ComputerName hq-azuresync -ScriptBlock { Start-ADSyncSyncCycle -PolicyType Delta }
            }
            else 
            {
                $test
            }

            #  Disable User Account
            Disable-ADAccount -Identity $userAccount
            Write-Host "`nThe AD account was successfully disabled. `n"

            #  Deactivate user's account in Okta.
            Disable-OktaUser $userAccount
            Write-Host "`nTheir Okta account has been deactivated. `n"

            #  Remove all Office365 licenses.
            (get-MsolUser -UserPrincipalName $o365Account).licenses.AccountSkuId |
            foreach{
                Set-MsolUserLicense -UserPrincipalName $o365Account -RemoveLicenses $_
            }

            Write-Host "`nOffice 365 licenses have been removed. `n"

            #  Move user account to the 'Disabled Users' OU.
            Get-ADUser $userAccount | Move-ADObject -TargetPath "OU=Disabled Users,DC=domain,DC=com"
          }       
          N {
            Write-Host –NoNewLine "`nStopping script."
            exit
          }
          Default {Write-Host "`nStopping script.`n"}  
    }
    $value = Read-Host "`nDo you want to enter another user? ( y | n )"
}
while ($value -notmatch 'n')

Write-Host "`nForcing the domain controller sync. `n"

#  Force a domain controller sync.
cmd /c "repadmin /syncall domaincontroller.domain.com DC=llmhq,DC=com /force"

Write-Host "Restarting IIS on email server 1. `n"

#  Wait 1 min. before bouncing email server 1.
Start-Sleep -s 60

#  Perform iisreset only on email server 1.
invoke-command -computername "email server 1" -scriptblock {iisreset /RESTART} 

Write-Host "Waiting 5 min. before restarting IIS on email server 2. `n"

#  Wait 5 min. before bouncing hq-email02.
Start-Sleep -s 300

Write-Host "Restarting IIS on email server 2. `n"

#  Perform iisreset only on email server 2.
invoke-command -computername "email server 2" -scriptblock {iisreset /RESTART} 




