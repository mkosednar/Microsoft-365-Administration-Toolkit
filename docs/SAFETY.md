# Safety and permissions

- The included inventory scripts are read-only. They retrieve directory or mailbox metadata and write CSV files locally; they do not create, update, disable, license, or delete tenant objects.
- Use a dedicated administrative account and grant only the delegated Microsoft Graph permissions required by the selected report. Your tenant may require administrator consent.
- User inventory: `User.Read.All`. Group inventory: `Group.Read.All`. License inventory: `Organization.Read.All`.
- Exchange mailbox inventory requires the appropriate Exchange Online RBAC role/cmdlet permissions for `Get-EXOMailbox`.
- Confirm the signed-in tenant and account before running scripts. Do not run reports against a production tenant unless authorized.
- CSV exports can contain personal and organizational information. Store them in an approved restricted location and follow retention requirements.
- Never commit access tokens, passwords, certificates, private keys, tenant exports, or real customer data.
- These scripts have not been executed against a live tenant in this repository. Validate module versions, permissions, and output in a test tenant before operational use.
- Microsoft Graph SDK and Exchange Online module cmdlets evolve. Check the linked Microsoft Learn documentation before production deployment.

These examples are operational starting points and are not a compliance certification.
