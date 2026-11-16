[CmdletBinding()]
param(
    [string]$OutputDirectory = (Join-Path $PSScriptRoot "..\..\Reports")
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$requiredScope = "Group.Read.All"
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Authentication)) {
    throw "Microsoft.Graph.Authentication is not installed. Run: Install-Module Microsoft.Graph -Scope CurrentUser"
}
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Groups)) {
    throw "Microsoft.Graph.Groups is not installed. Run: Install-Module Microsoft.Graph -Scope CurrentUser"
}

Import-Module Microsoft.Graph.Authentication -ErrorAction Stop
Import-Module Microsoft.Graph.Groups -ErrorAction Stop

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

$reportPath = Join-Path $resolvedOutputDirectory ("M365-Groups-{0}.csv" -f (Get-Date -Format "yyyyMMdd-HHmmss"))
$groups = Get-MgGroup -All -Property "id,displayName,description,mail,mailEnabled,securityEnabled,groupTypes,visibility,createdDateTime"
$report = $groups | Sort-Object DisplayName | Select-Object Id, DisplayName, Description, Mail, MailEnabled, SecurityEnabled, @{Name = "GroupTypes"; Expression = { @($_.GroupTypes) -join ";" } }, Visibility, CreatedDateTime

$report | Export-Csv -Path $reportPath -NoTypeInformation -Encoding utf8
Write-Host "Exported $($report.Count) groups to $reportPath" -ForegroundColor Green
