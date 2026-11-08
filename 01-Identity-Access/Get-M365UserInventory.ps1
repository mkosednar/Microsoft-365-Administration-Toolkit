[CmdletBinding()]
param([string]$OutputDirectory = (Join-Path $PSScriptRoot "..\..\Reports"))
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$requiredScope = "User.Read.All"
$context = Get-MgContext
if (-not $context) { Connect-MgGraph -Scopes $requiredScope; $context = Get-MgContext }
if ($context -and $context.Scopes -notcontains $requiredScope) { throw "Current Graph session lacks $requiredScope. Run Disconnect-MgGraph, then rerun this script." }
New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
$reportPath = Join-Path $OutputDirectory ("M365-Users-{0}.csv" -f (Get-Date -Format "yyyyMMdd-HHmmss"))
$users = Get-MgUser -All -Property "id,displayName,userPrincipalName,mail,accountEnabled,userType,createdDateTime,assignedLicenses"
$report = $users | Sort-Object UserPrincipalName | Select-Object Id,DisplayName,UserPrincipalName,Mail,AccountEnabled,UserType,CreatedDateTime,@{Name="AssignedLicenseCount";Expression={@($_.AssignedLicenses).Count}}
$report | Export-Csv -Path $reportPath -NoTypeInformation -Encoding utf8
Write-Host "Exported $($report.Count) users to $reportPath" -ForegroundColor Green
