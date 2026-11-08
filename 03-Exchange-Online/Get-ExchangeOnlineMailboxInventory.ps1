[CmdletBinding()]
param([string]$OutputDirectory = (Join-Path $PSScriptRoot "..\..\Reports"))
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) { throw "ExchangeOnlineManagement is not installed. Run: Install-Module ExchangeOnlineManagement -Scope CurrentUser" }
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline -ShowBanner:$false
New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
$reportPath = Join-Path $OutputDirectory ("Exchange-Mailboxes-{0}.csv" -f (Get-Date -Format "yyyyMMdd-HHmmss"))
$mailboxes = Get-EXOMailbox -ResultSize Unlimited -Properties DisplayName,UserPrincipalName,PrimarySmtpAddress,RecipientTypeDetails,WhenMailboxCreated
$report = $mailboxes | Sort-Object UserPrincipalName | Select-Object DisplayName,UserPrincipalName,PrimarySmtpAddress,RecipientTypeDetails,WhenMailboxCreated
$report | Export-Csv -Path $reportPath -NoTypeInformation -Encoding utf8
Write-Host "Exported $($report.Count) mailboxes to $reportPath" -ForegroundColor Green
Write-Host "The Exchange Online session remains open. Run Disconnect-ExchangeOnline when finished."
