#  Each user has a 
#  separate, personal, network drive 
#  on their workstation.  This 
#  script uploads all the 
#  contents of that folder 
#  to OneDrive.  Reason being 
#  is our move to 
#  Office 365 & pushing 
#  for the use of 
#  OneDrive/SharePoint.

$email = "office365admin@domain.onmicrosoft.com"
$office365pw = Get-Content 'C:\office365adminpw.txt' | ConvertTo-SecureString
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $email, $office365pw

#  Add Site Collection Administrator in SharePoint Online
$AdminURL = "https://domain-admin.sharepoint.com/"
#  Connect to SharePoint Online
Connect-SPOService -url $AdminURL -Authentication Kerberos -Credential $cred

$user = ""

#  Add Site collection Admin
$url = "https://domain-my.sharepoint.com/personal/" +$user+ "_domain_com"

Set-SPOUser -site $url -LoginName "office365admin@domain.onmicrosoft.com" -IsSiteCollectionAdmin $True 


Connect-PnPOnline –Url $url -Credentials $cred 

#  Add folder to each user's OneDrive.
Add-PnPFolder -Name "From_P_Drive" -Folder "Documents"
Add-PnPFolder -Name "Desktop" -Folder "Documents"
Add-PnPFolder -Name "My Documents" -Folder "Documents"

#  Upload the contents of their P: drive to the newly created folder in OneDrive.
$LocalPath = "\\domain.com\root\FSData\FS1\Home\$user\"
$fullPath = (Get-Item $LocalPath).FullName

#  Uploads only the files to the folder.  
$files = Get-ChildItem $LocalPath
$files | ForEach-Object {
    Add-PnPFile -Path $_.FullName -Folder Documents\From_P_Drive -Values @{Modified=$_.LastWriteTimeUtc;} -erroraction 'silentlycontinue'
}

#  Uploads folders & subfolders.
$documentLibraryName = 'Documents\From_P_Drive\'
$file = Get-ChildItem -Path $LocalPath -Recurse
$i = 0;
(dir $LocalPath -Recurse) | %{
  try{ 
      $i++
if($_.GetType().Name -eq "FileInfo"){
   $SPFolderName =  $documentLibraryName + $_.DirectoryName.Substring($LocalPath.Length);
   $status = "Uploading Files :'" + $_.Name + "' to Location :" + $SPFolderName
    $te = Add-PnPFile -Path $_.FullName -Folder $SPFolderName -Values @{Modified=$_.LastWriteTimeUtc;}

}        
    }
catch{ }
}

#  Remove Site Collection Administrator in SharePoint Online
Set-SPOUser -site "https://domain-my.sharepoint.com/personal/" +$user+ "_domain_com" -LoginName "office365admin@domain.onmicrosoft.com" -IsSiteCollectionAdmin $False