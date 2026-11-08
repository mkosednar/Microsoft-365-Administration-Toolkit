[CmdletBinding()]
param([string]$OutputDirectory = (Join-Path $PSScriptRoot "..\..\Reports"))
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$requiredScope = "Organization.Read.All"
$context = Get-MgContext
if (-not $context) { Connect-MgGraph -Scopes $requiredScope; $context = Get-MgContext }
if ($context -and $context.Scopes -notcontains $requiredScope) { throw "Current Graph session lacks $requiredScope. Run Disconnect-MgGraph, then rerun this script." }
New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
$reportPath = Join-Path $OutputDirectory ("M365-Licenses-{0}.csv" -f (Get-Date -Format "yyyyMMdd-HHmmss"))
$skus = Get-MgSubscribedSku -All
$report = $skus | Sort-Object SkuPartNumber | Select-Object SkuId,SkuPartNumber,CapabilityStatus,@{Name="EnabledUnits";Expression={$_.PrepaidUnits.Enabled}},@{Name="WarningUnits";Expression={$_.PrepaidUnits.Warning}},@{Name="SuspendedUnits";Expression={$_.PrepaidUnits.Suspended}},ConsumedUnits
$report | Export-Csv -Path $reportPath -NoTypeInformation -Encoding utf8
Write-Host "Exported $($report.Count) subscribed SKUs to $reportPath" -ForegroundColor Green
