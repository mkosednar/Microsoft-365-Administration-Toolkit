[CmdletBinding()]
param(
    [string]$OutputDirectory = (Join-Path $PSScriptRoot "..\..\Reports")
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
    throw "ExchangeOnlineManagement is not installed. Run: Install-Module ExchangeOnlineManagement -Scope CurrentUser"
}
Import-Module ExchangeOnlineManagement -ErrorAction Stop

$connectedByScript = $false
try {
    Connect-ExchangeOnline -ShowBanner:$false -ErrorAction Stop
    $connectedByScript = $true

    $connection = Get-ConnectionInformation | Select-Object -First 1
    if ($connection) {
        Write-Host "Connected Exchange Online account: $($connection.UserPrincipalName) | Organization: $($connection.Organization)" -ForegroundColor Cyan
    }

    $resolvedOutputDirectory = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputDirectory)
    New-Item -ItemType Directory -Path $resolvedOutputDirectory -Force | Out-Null

    $reportPath = Join-Path $resolvedOutputDirectory ("Exchange-Mailboxes-{0}.csv" -f (Get-Date -Format "yyyyMMdd-HHmmss"))
    $mailboxes = Get-EXOMailbox -ResultSize Unlimited -Properties DisplayName, UserPrincipalName, PrimarySmtpAddress, RecipientTypeDetails, WhenMailboxCreated -ErrorAction Stop
    $report = $mailboxes | Sort-Object UserPrincipalName | Select-Object DisplayName, UserPrincipalName, PrimarySmtpAddress, RecipientTypeDetails, WhenMailboxCreated

    $report | Export-Csv -Path $reportPath -NoTypeInformation -Encoding utf8
    Write-Host "Exported $($report.Count) mailboxes to $reportPath" -ForegroundColor Green
}
finally {
    if ($connectedByScript) {
        Disconnect-ExchangeOnline -Confirm:$false -ErrorAction SilentlyContinue
    }
}
