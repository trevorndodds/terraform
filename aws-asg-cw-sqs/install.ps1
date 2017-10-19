Param(
  [string]$serverName,
  [string]$directorURL,
  [string]$engineConfig
)

if (Get-Service DataSynapse -ErrorAction SilentlyContinue) {
  $service = Get-WmiObject -Class Win32_Service -Filter "name='DataSynapse'"
  $service.StopService()
  Start-Sleep -s 1
  $service.delete()
}

$workdir = Split-Path $MyInvocation.MyCommand.Path

New-Service -name DataSynapse `
  -displayName "DataSynapse Engine" `
  -Description "DataSynapse Engine" `
  -StartupType "Manual" `
  -binaryPathName "`"$workdir\enginesv.exe`""

if($serverName)
  {
    Write-Output "Updating Profile ComputerName to match Server"
    Rename-Item $workdir\profiles\computername $workdir\profiles\$serverName
    SchTasks.exe /Create /SC onstart /TN DataSynapse /TR "C:\windows\system32\WindowsPowerShell\v1.0\powershell.exe $workdir\checkDomainJoin.ps1" /RU System
  }

if($engineConfig)
  {
  Write-Output "Setting engineConfig to $engineConfig" 
  [IO.File]::WriteAllText("$workdir\profiles\$serverName\distro.dat", $engineConfig)
  }

if($directorURL)
  {
  Write-Output "Setting directorURL to $directorURL" 
  $director = "$directorURL/livecluster/public_html/register/register.jsp" + "`r`n" + "jre=local"
  [IO.File]::WriteAllText("$workdir\intranet.dat", "$director")
  }
