# Microsoft-365-Administration-Toolkit

A collection of PowerShell scripts and practical examples for Microsoft 365 administration, including Microsoft Entra ID, Exchange Online, licensing, security, and reporting.

## Repository status

This repository currently contains read-only inventory scripts. Planned areas are not represented as implemented functionality.

## Requirements

- PowerShell 7 recommended.
- Microsoft Graph PowerShell SDK for directory and license inventory.
- ExchangeOnlineManagement module for Exchange Online mailbox inventory.
- An account authorized for the required tenant data and API permissions.

Install modules as needed:

```powershell
Install-Module Microsoft.Graph -Scope CurrentUser
Install-Module ExchangeOnlineManagement -Scope CurrentUser
```

## Included scripts

| Script | Purpose | Required delegated Graph scope / access |
|---|---|---|
| `01-Identity-Access/Get-M365UserInventory.ps1` | Export user identity, status, user type, creation date and assigned-license count | `User.Read.All` |
| `01-Identity-Access/Get-M365GroupInventory.ps1` | Export group metadata and group types | `Group.Read.All` |
| `01-Identity-Access/Get-M365LicenseInventory.ps1` | Export subscribed SKU capacity and consumption | `Organization.Read.All` |
| `03-Exchange-Online/Get-ExchangeOnlineMailboxInventory.ps1` | Export Exchange Online mailbox metadata | Exchange RBAC permission for `Get-EXOMailbox` |

The scripts use interactive sign-in and do not store credentials. Graph scripts reuse an existing Graph session only when the required scope is present; otherwise, they stop with instructions to reconnect.

## Quick start

Run a script from the repository root, for example:

```powershell
./01-Identity-Access/Get-M365UserInventory.ps1
```

Reports are written to the local `Reports/` directory with timestamped filenames. The directory and CSV files are excluded by `.gitignore`.

For Exchange Online, install the module and run:

```powershell
Install-Module ExchangeOnlineManagement -Scope CurrentUser
./03-Exchange-Online/Get-ExchangeOnlineMailboxInventory.ps1
Disconnect-ExchangeOnline
```

## Safety

All currently included scripts are read-only inventory/reporting examples. They still access sensitive tenant metadata; protect the resulting CSV files. Review [docs/SAFETY.md](docs/SAFETY.md) before use.

## Planned areas

- Entra ID access reviews, role and authentication-method reporting
- Exchange Online mail flow and configuration audits
- SharePoint Online and OneDrive reporting
- Teams configuration and governance reports
- Conditional Access and security posture review
- License assignment analysis and optimization

## Validation status

Scripts are designed around Microsoft Graph PowerShell SDK and ExchangeOnlineManagement cmdlets documented by Microsoft. They have not been run against a live tenant in this repository. Test in a non-production tenant and verify permissions and module versions before production use.

## Official documentation

- [Microsoft Graph PowerShell](https://learn.microsoft.com/en-us/powershell/microsoftgraph/)
- [Microsoft Graph PowerShell authentication](https://learn.microsoft.com/en-us/powershell/microsoftgraph/authentication-commands)
- [Connect to Exchange Online PowerShell](https://learn.microsoft.com/en-us/powershell/exchange/connect-to-exchange-online-powershell)

## License

No license has been selected. Unless a license is added, standard copyright applies and reuse/redistribution permissions are not granted.
