[CmdletBinding()]
param(
    [string]$OutputDirectory = (Join-Path $PSScriptRoot "..\..\Reports")
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$requiredScope = "Organization.Read.All"
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Authentication)) {
    throw "Microsoft.Graph.Authentication is not installed. Run: Install-Module Microsoft.Graph -Scope CurrentUser"
}
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Identity.DirectoryManagement)) {
    throw "Microsoft.Graph.Identity.DirectoryManagement is not installed. Run: Install-Module Microsoft.Graph -Scope CurrentUser"
}

Import-Module Microsoft.Graph.Authentication -ErrorAction Stop
Import-Module Microsoft.Graph.Identity.DirectoryManagement -ErrorAction Stop

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

$reportPath = Join-Path $resolvedOutputDirectory ("M365-Licenses-{0}.csv" -f (Get-Date -Format "yyyyMMdd-HHmmss"))
$skus = Get-MgSubscribedSku -All
$report = $skus | Sort-Object SkuPartNumber | Select-Object SkuId, SkuPartNumber, CapabilityStatus, @{Name = "EnabledUnits"; Expression = { $_.PrepaidUnits.Enabled } }, @{Name = "WarningUnits"; Expression = { $_.PrepaidUnits.Warning } }, @{Name = "SuspendedUnits"; Expression = { $_.PrepaidUnits.Suspended } }, ConsumedUnits

$report | Export-Csv -Path $reportPath -NoTypeInformation -Encoding utf8
Write-Host "Exported $($report.Count) subscribed SKUs to $reportPath" -ForegroundColor Green
