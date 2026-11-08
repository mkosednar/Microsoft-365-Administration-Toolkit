[CmdletBinding()]
param([string]$OutputDirectory = (Join-Path $PSScriptRoot "..\..\Reports"))
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$requiredScope = "Group.Read.All"
$context = Get-MgContext
if (-not $context) { Connect-MgGraph -Scopes $requiredScope; $context = Get-MgContext }
if ($context -and $context.Scopes -notcontains $requiredScope) { throw "Current Graph session lacks $requiredScope. Run Disconnect-MgGraph, then rerun this script." }
New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
$reportPath = Join-Path $OutputDirectory ("M365-Groups-{0}.csv" -f (Get-Date -Format "yyyyMMdd-HHmmss"))
$groups = Get-MgGroup -All -Property "id,displayName,description,mail,mailEnabled,securityEnabled,groupTypes,visibility,createdDateTime"
$report = $groups | Sort-Object DisplayName | Select-Object Id,DisplayName,Description,Mail,MailEnabled,SecurityEnabled,@{Name="GroupTypes";Expression={@($_.GroupTypes) -join ";"}},Visibility,CreatedDateTime
$report | Export-Csv -Path $reportPath -NoTypeInformation -Encoding utf8
Write-Host "Exported $($report.Count) groups to $reportPath" -ForegroundColor Green
