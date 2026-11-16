[CmdletBinding()]
param(
    [string]$OutputDirectory = (Join-Path $PSScriptRoot "..\..\Reports")
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$requiredScope = "User.Read.All"
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Authentication)) {
    throw "Microsoft.Graph.Authentication is not installed. Run: Install-Module Microsoft.Graph -Scope CurrentUser"
}
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Users)) {
    throw "Microsoft.Graph.Users is not installed. Run: Install-Module Microsoft.Graph -Scope CurrentUser"
}

Import-Module Microsoft.Graph.Authentication -ErrorAction Stop
Import-Module Microsoft.Graph.Users -ErrorAction Stop

$context = Get-MgContext
if (-not $context) {
    Connect-MgGraph -Scopes $requiredScope -NoWelcome
    $context = Get-MgContext
}
if (-not $context -or $context.Scopes -notcontains $requiredScope) {
    throw "Current Graph session lacks $requiredScope. Run Disconnect-MgGraph, then rerun this script."
}

Write-Host "Connected tenant: $($context.TenantId) | Account: $($context.Account)" -ForegroundColor Cyan
$resolvedOutputDirectory = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputDirectory)
New-Item -ItemType Directory -Path $resolvedOutputDirectory -Force | Out-Null

$reportPath = Join-Path $resolvedOutputDirectory ("M365-Users-{0}.csv" -f (Get-Date -Format "yyyyMMdd-HHmmss"))
$users = Get-MgUser -All -Property "id,displayName,userPrincipalName,mail,accountEnabled,userType,createdDateTime,assignedLicenses"
$report = $users | Sort-Object UserPrincipalName | Select-Object Id, DisplayName, UserPrincipalName, Mail, AccountEnabled, UserType, CreatedDateTime, @{Name = "AssignedLicenseCount"; Expression = { @($_.AssignedLicenses).Count } }

$report | Export-Csv -Path $reportPath -NoTypeInformation -Encoding utf8
Write-Host "Exported $($report.Count) users to $reportPath" -ForegroundColor Green
