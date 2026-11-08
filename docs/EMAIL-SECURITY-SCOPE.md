# Email security project scope

This document defines the safe boundaries for the email-security work in this toolkit. It is a planning document; it does not change any tenant or mailbox settings.

## Supported platforms

### Microsoft 365 / Exchange Online

Use Microsoft Entra ID and Exchange Online administration interfaces and supported reporting capabilities. Keep identity controls (MFA, Conditional Access, sign-in risk and OAuth consent) separate from mailbox protocol settings.

Audit at least:
- Per-mailbox POP and IMAP configuration.
- Tenant- and mailbox-level SMTP AUTH configuration, including exceptions.
- Authentication method and modern-authentication readiness.
- Sign-in and audit-log signals, where licensing and permissions allow.
- Application access and OAuth grants, where authorized.

Do not infer that a protocol is safe to disable merely because it is enabled. Identify the application, device, business owner and last-use evidence first. SMTP AUTH can be required by scanners, multifunction devices and line-of-business applications even when users read mail with Outlook.

### Google Workspace / Gmail

Use the Google Admin console and supported Admin SDK / Reports API capabilities. Do not reuse Exchange Online cmdlets or assume equivalent setting names.

Audit at least:
- User and organizational-unit Gmail POP/IMAP access policies.
- OAuth application access and third-party app controls.
- 2-Step Verification enrollment and enforcement status.
- Login and audit events available to the Workspace edition and assigned roles.
- App passwords and legacy access paths, where applicable.

Distinguish Google Workspace accounts from personal Gmail accounts. Workspace administrator controls do not apply to consumer Gmail in the same way.

## Outlook compatibility

Test each real client configuration before changing protocol policy:
1. Outlook for Windows (record version, account type and authentication method).
2. Outlook for Android (record app version and account type).
3. Send, receive, calendar and contacts where applicable.
4. Shared mailboxes, delegated access and mobile-device scenarios where applicable.
5. Any scanners, printers, scripts or business applications that send mail.

Modern Outlook clients commonly use modern authentication, but compatibility must be verified for the actual client, tenant policy and account type. POP/IMAP and SMTP AUTH are separate capabilities; do not treat them as one switch.

## Safe delivery sequence

1. **Inventory only:** collect configuration and available usage evidence; make no changes.
2. **Classify:** identify owners, business purpose, dependencies and exceptions.
3. **Pilot:** test a small set of designated test accounts and representative devices.
4. **Review:** obtain explicit change approval and document expected impact.
5. **Change gradually:** use supported controls, narrow scope and a tested recovery plan.
6. **Verify:** test sign-in, send/receive and dependent applications; retain before/after evidence and an audit trail.

No script in this project may silently apply tenant-wide changes. Any future write operation must require explicit opt-in, support the PowerShell WhatIf mechanism where the command supports it, log the target and intended change, and document rollback limitations. A rollback is not guaranteed for every identity or security-policy change; recovery steps must be validated in advance.

## Minimum operational safeguards

- Use least-privilege roles and document required permissions per report.
- Confirm tenant identity before every administrative run.
- Keep a tested emergency administrator account and verified recovery methods.
- Never store credentials, access tokens, private keys or app secrets in source control.
- Treat CSV reports and sign-in data as sensitive; restrict access and retention.
- Record module/API versions and test against a non-production tenant first.
- Mark unavailable telemetry as **not assessed**, never as **no risk found**.

## Current implementation status

The existing toolkit contains read-only Microsoft 365 inventory scripts. This document does not claim that protocol, authentication or Google Workspace audits have been implemented. Those capabilities require separate design, permission review and tests before being described as available.
