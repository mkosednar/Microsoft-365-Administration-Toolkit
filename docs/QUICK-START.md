# Quick start

## Microsoft Graph reports

1. Open PowerShell 7.
2. Install the SDK if needed: `Install-Module Microsoft.Graph -Scope CurrentUser`.
3. Run the desired script from the repository root.
4. Sign in interactively and approve the requested delegated permission if prompted.
5. Review the generated CSV in `Reports/` and handle it as sensitive tenant data.

If an existing Graph session has insufficient scopes, run `Disconnect-MgGraph` and start the script again.

## Exchange Online report

1. Install the module: `Install-Module ExchangeOnlineManagement -Scope CurrentUser`.
2. Run `./03-Exchange-Online/Get-ExchangeOnlineMailboxInventory.ps1`.
3. Complete interactive sign-in.
4. Run `Disconnect-ExchangeOnline` when finished.

Use an authorized test tenant first. See [SAFETY.md](SAFETY.md) for permissions and handling guidance.
