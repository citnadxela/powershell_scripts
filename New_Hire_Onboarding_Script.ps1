##  This script automates the 
##  checklist that used to 
##  be done by the Help Desk.  

Import-Module ActiveDirectory

Write-Host "`nWhat department is the new hire going to be working for?`n"
    
$Title = 'Departments'

     Write-Host "================ $Title ================"
     
     Write-Host "1:  Press  '1' for Accounting"
     Write-Host "2:  Press  '2' for Art Department"
     Write-Host "3:  Press  '3' for Bid"
     Write-Host "4:  Press  '4' for Contractors-Consultants"
     Write-Host "5:  Press  '5' for Customer Service"
     Write-Host "6:  Press  '6' for Editorial Department"
     Write-Host "7:  Press  '7' for Export"
     Write-Host "8:  Press  '8' for Finance"
     Write-Host "9:  Press  '9' for HR"
     Write-Host "10: Press '10' for IS Dev"
     Write-Host "11: Press '11' for IS Operations"
     Write-Host "12: Press '12' for Kids and Company"
     Write-Host "13: Press '13' for Marketing Department"
     Write-Host "14: Press '14' for Merchandising"
     Write-Host "15: Press '15' for Operations"
     Write-Host "16: Press '16' for Order Department"
     Write-Host "17: Press '17' for Product Art"
     Write-Host "18: Press '18' for Purchasing"
     Write-Host "19: Press '19' for Quality Assurance"
     Write-Host "20: Press '20' for Research & Development"
     Write-Host "21: Press '21' for Retail Department"
     Write-Host "22: Press '22' for Sales & Marketing"
     Write-Host "23: Press '23' for Solutions"
     Write-Host "24: Press '24' for Testing"
     Write-Host "25: Press '25' for Traffic"
     Write-Host "26: Press '26' for Training"
     Write-Host "27: Press '27' for Vendor Relations"
     Write-Host "28: Press '28' for Warehouse"
     Write-Host "29: Press '29' for Web"
     Write-Host "Q:  Press 'Q' to quit`n"

do{
$input = Read-Host "Please make a selection"
     switch ($input)
     {
           '1' {
                $dept = 'Accounting'
                $desc = 'Accounting'
                [string] $Path = "OU=Accounting,OU=Domain Users,DC=domain,DC=com"
           } '2' {
                $dept = 'Art Department'
                $desc = 'Art'
                [string] $Path = "OU=Art Department,OU=Domain Users,DC=domain,DC=com"
           } '3' {
                $dept = 'Bid'
                $desc = 'Bid'
                [string] $Path = "OU=Bid,OU=Domain Users,DC=domain,DC=com"
           } '4' {
                $dept = 'Contractors-Consultants'
                $desc = 
                [string] $Path = "OU=Contractors-Consultants,OU=Domain Users,DC=domain,DC=com"
           } '5' {
                $dept = 'Customer Service'
                $desc = 'Customer Service'
                [string] $Path = "OU=Customer Service,OU=Domain Users,DC=domain,DC=com"
           } '6' {
                $dept = 'Editorial Department'
                $desc = 'Editorial'
                [string] $Path = "OU=Editorial Department,OU=Domain Users,DC=domain,DC=com"
           } '7' {
                $dept = 'Export'
                $desc = 'Export'
                [string] $Path = "OU=Export,OU=Domain Users,DC=domain,DC=com"
           } '8' {
                $dept = 'Finance'
                $desc = 'Finance'
                [string] $Path = "OU=Finance,OU=Domain Users,DC=domain,DC=com"
           } '9' {
                $dept = 'HR'
                $desc = 'Human Resources'
                [string] $Path = "OU=HR,OU=Domain Users,DC=domain,DC=com"
           } '10' {
                $dept = 'IS Dev'
                $desc = 'IS Dev'
                [string] $Path = "OU=IS Dev,OU=Domain Users,DC=domain,DC=com"
           } '11' {
                $dept = 'IS Operations'
                $desc = 'IT Ops'
                [string] $Path = "OU=IS Operations,OU=Domain Users,DC=domain,DC=com"
           } '12' {
                $dept = 'Kids and Company'
                $desc = 'Kids & Co'
                [string] $Path = "OU=Kids and Company,OU=Domain Users,DC=domain,DC=com"
           } '13' {
                $dept = 'Marketing Department'
                $desc = 'Marketing'
                [string] $Path = "OU=Marketing Department,OU=Domain Users,DC=domain,DC=com"
           } '14' {
                $dept = 'Merchandising'
                $desc = 'Merchandising'
                [string] $Path = "OU=Merchandising,OU=Domain Users,DC=domain,DC=com"
           } '15' {
                $dept = 'Operations'
                $desc = 'Operations'
                [string] $Path = "OU=Operations,OU=Domain Users,DC=domain,DC=com"
           } '16' {
                $dept = 'Order Department'
                $desc = 'Order'
                [string] $Path = "OU=Order Department,OU=Domain Users,DC=domain,DC=com"
           } '17' {
                $dept = 'Product Art'
                $desc = 'Product Art'
                [string] $Path = "OU=Product Art,OU=Domain Users,DC=domain,DC=com"
           } '18' {
                $dept = 'Purchasing'
                $desc = 'Purchasing'
                [string] $Path = "OU=Purchasing,OU=Domain Users,DC=domain,DC=com"
           } '19' {
                $dept = 'Quality Assurance'
                $desc = 'Quality Assurance'
                [string] $Path = "OU=Quality Assurance,OU=Domain Users,DC=domain,DC=com"
           } '20' {
                $dept = 'Research & Development'
                $desc = 'R & D'
                [string] $Path = "OU=Research & Development,OU=Domain Users,DC=domain,DC=com"
           } '21' {
                $dept = 'Retail Department'
                $desc = 'Retail'
                [string] $Path = "OU=Retail Department,OU=Domain Users,DC=domain,DC=com"
           } '22' {
                $dept = 'Sales & Marketing'
                $desc = 'Sales'
                [string] $Path = "OU=Sales & Marketing,OU=Domain Users,DC=domain,DC=com"
           } '23' {
                $dept = 'Solutions'
                $desc = 'Solutions'
                [string] $Path = "OU=Solutions,OU=Domain Users,DC=domain,DC=com"
           } '24' {
                $dept = 'Testing'
                $desc = 'Testing'
                [string] $Path = "OU=Testing,OU=Domain Users,DC=domain,DC=com"
           } '25' {
                $dept = 'Traffic'
                $desc = 'Traffic'
                [string] $Path = "OU=Traffic,OU=Domain Users,DC=domain,DC=com"
           } '26' {
                $dept = 'Training'
                $desc = 'Training'
                [string] $Path = "OU=Training,OU=Domain Users,DC=domain,DC=com"
           } '27' {
                $dept = 'Vendor Relations'
                $desc = 'Vendor Relations'
                [string] $Path = "OU=Vendor Relations,OU=Domain Users,DC=domain,DC=com"
           } '28' {
                $dept = 'Warehouse'
                $desc = 'Warehouse'
                [string] $Path = "OU=Warehouse,OU=Domain Users,DC=domain,DC=com"
           } '29' {
                $dept = 'Web'
                $desc = 'E-Com'
                [string] $Path = "OU=Web,OU=Domain Users,DC=domain,DC=com"
           } 'q' {
                exit
           }
           default {Write-Host "`nInvalid entry.  Please re-enter:`n"}
        }
    }
until ('1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29' -contains $input)

    $Firstname = Read-Host "`nWhat is the user's first name?"
    $Lastname = Read-Host "`nWhat is the user's last name?"
    $FullName = "$Firstname $Lastname"

    $ReadTelephoneNo = Read-Host "`nWhat is the user's extension number?"
    $tempPassword = (ConvertTo-SecureString "Welcome2!" -AsPlainText -force)

    for ($i = 1; $i -le $FirstName.Length; $i++) {
        $Account = $null
        $Identity = $FirstName.Substring(0,$i) + $LastName
        $SamAccName = $Identity.ToLower()
        $Account = Get-ADUser -Filter "sAMAccountName -eq '$SamAccName'"
        if ($Account -eq $null) {
            New-ADUser -Name $FullName -GivenName $Firstname -Surname $Lastname -SamAccountName $SamAccName -UserPrincipalName "$SamAccName@domain.com" -Path "OU=Users,OU=$dept,OU=Domain Users,DC=domain,DC=com" -DisplayName $FullName -Enabled $true -ChangePasswordAtLogon $true -AccountPassword $tempPassword -OfficePhone "x$ReadTelephoneNo" -ScriptPath "kixtart" #-Description "$desc ($ReadTelephoneNo)" -Office $desc
            break;
        };
    }

#  prompt for password then store it in that txt file.  (not part of script, but needs to be done beforehand).
#read-host -assecurestring | convertfrom-securestring | out-file C:\newHire.txt

$RemoteRoutingAddress = $SamAccName+'@domain.mail.onmicrosoft.com'

#  Connect to on-prem exchange (hybrid environment).
$username = "administrator"
$password = Get-Content 'C:\Windows\powershellSession.txt' | ConvertTo-SecureString
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $password
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri URL -Authentication Kerberos -Credential $cred
Import-PSSession $Session

#  Create e-mail account/mailbox directly in Office 365.
Enable-RemoteMailbox -Identity $SamAccName -RemoteRoutingAddress $RemoteRoutingAddress

#  Sync Azure AD.
Invoke-Command -ComputerName hq-azuresync -ScriptBlock { Start-ADSyncSyncCycle -PolicyType Delta }

Set-ADUser -Identity $SamAccName -Email "$SamAccName@domain.com"

Write-Host "`nUser's Active Directory & e-mail account has been created.  Please complete the following now:`n
1.  Add the user to their respective Groups & e-mail distribution lists.
2.  Create User Extranet account & mirror privileges of a user in a similar job position.
3.  Assign the user the respective Office 365 license."

