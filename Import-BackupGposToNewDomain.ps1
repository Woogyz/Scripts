$gpos = Get-ChildItem C:\users\Administrator\Desktop -Directory

foreach ( $gpo in $gpos )
{
    Write-Host -ForegroundColor Gray "Processing $($content.GroupPolicyBackupScheme.GroupPolicyObject.GroupPolicyCoreSettings.DisplayName.'#cdata-section')."
    [xml]$content = Get-Content "$($gpo.FullName)\Backup.xml"
    
    try
    {
        $newGPO = New-GPO $content.GroupPolicyBackupScheme.GroupPolicyObject.GroupPolicyCoreSettings.DisplayName.'#cdata-section' -ErrorAction Stop
        Write-Host -ForegroundColor Yellow "-> GPO  does not exist - creating new"
    }
    catch
    {
        if ( $_.Exception -match "GPO already exists in the")
        {
            Write-Host -ForegroundColor Gray "-> GPO already exists - not creating new."
        }
    }

    Write-Host -ForegroundColor Yellow "--> Importing settings.."

    try
    {
        $import = Import-GPO -BackupGpoName $content.GroupPolicyBackupScheme.GroupPolicyObject.GroupPolicyCoreSettings.DisplayName.'#cdata-section' -TargetName $content.GroupPolicyBackupScheme.GroupPolicyObject.GroupPolicyCoreSettings.DisplayName.'#cdata-section' -Path 'C:\Users\Administrator\Desktop' -ErrorAction Stop
        Write-Host -ForegroundColor Green "---> Settings imported successfully"
    }
    catch
    {
        Write-Host -ForegroundColor Red "---> Settings import failed"
    }
    Write-Host
}