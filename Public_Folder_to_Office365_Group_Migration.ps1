#  This script migrates existing Public Folders that are on-premises to a group that exists in Office 365.

#  Step 1 is to create a new Office 365 Group (Team) or know/use (the SMTP of) an existing one.
#  Get-UnifiedGroup = Get all Office 365 groups.
#  TargetGroupMailbox = SMTP address of Office 365 group.
#  After creating a new Office 365 Group, must unhide it:  Set-UnifiedGroup -Identity "Legal Department" -HiddenFromAddressListsEnabled $false
#  For public folders wi/ subfolders, have to run a migration batch individually for each item.
#  How to remove migration endpoint:  Remove-MigrationEndpoint -Identity CrossForestME01
#  Have to add user as owner of public folder to successfully complete a migration batch.

#  How to add user as Owner to Public Folder
Add-PublicFolderClientPermission -Identity "\2 - Departments\IS\IS - Systems Calendar\" -User 'domain.com/Domain Users/' -AccessRights Owner
Add-PublicFolderClientPermission -Identity "\2 - Departments\IS\" -User 'domain.com/Domain Users/IS Operations/Users/' -AccessRights Owner

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri URL -Authentication Kerberos 
Import-PSSession $Session

#  Login using AD creds. 
Connect-AzureAD
Connect-MsolService

#  Login using AD creds.  
$Session2 = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session2

Get-PublicFolder -Identity "\2 - Departments\IS"
Get-PublicFolder -Identity '\2 - Departments\IS' -Recurse | fl Name, Replicas, OriginatingServer

#  Step 3-Create the .csv

Get-Mailbox "atest@domain.com" | Select-Object LegacyExchangeDN
    #LegacyExchangeDN                                                                                                
    #----------------                                                                                                
    #/o=company/ou=Exchange Administrative Group (FYDIBOHF23SPDLT)/cn=Recipients/cn=Alex Testb8c

Get-RemoteMailbox "adantic@domain.com" | Select-Object LegacyExchangeDN
    #LegacyExchangeDN                                                                                               
    #----------------                                                                                               
    #/o=company/ou=External (FYDIBOHF25SPDLT)/cn=Recipients/cn=1b917071994d41738311d008c15e88fb



Get-ExchangeServer emaildb01 | Select-Object -Expand ExchangeLegacyDN
    #/o=company/ou=Exchange Administrative Group (FYDIBOHF23SPDLT)/cn=Configuration/cn=Servers/cn=EMAILDB01



Get-OutlookAnywhere | Format-Table Identity, ExternalHostName
    #Identity                          ExternalHostname 
    #--------                          ---------------- 
    #MAIL01\Rpc (Default Web Site) outlook.domain.com
    #EMAIL02\Rpc (Default Web Site) outlook.domain.com



$Source_Credential = Get-Credential

$Source_RemoteMailboxLegacyDN = "/o=company/ou=External (FYDIBOHF25SPDLT)/cn=Recipients/cn=1b917071994d41738311d008c15e88fb"
$Source_RemotePublicFolderServerLegacyDN = "/o=company/ou=Exchange Administrative Group (FYDIBOHF23SPDLT)/cn=Configuration/cn=Servers/cn=EMAILDB01"
$Source_OutlookAnywhereExternalHostName = "outlook.domain.com"

$PfEndpoint = New-MigrationEndpoint -PublicFolderToUnifiedGroup -Name PFToGroupEndpoint -RPCProxyServer $Source_OutlookAnywhereExternalHostName -Credentials $Source_Credential -SourceMailboxLegacyDN $Source_RemoteMailboxLegacyDN -PublicFolderDatabaseServerLegacyDN $Source_RemotePublicFolderServerLegacyDN -Authentication Basic

New-MigrationBatch -Name is__test -CSVData (Get-Content "C:\Users\user\Desktop\PFtoGroups\test1.csv" -Encoding Byte) -PublicFolderToUnifiedGroup -SourceEndpoint $PfEndpoint.Identity -NotificationEmails "user@domain.com" 
Start-MigrationBatch is__test




