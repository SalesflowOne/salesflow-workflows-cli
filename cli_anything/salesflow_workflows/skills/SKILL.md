---
name: "salesflow-workflows-cli"
description: "Salesflow Workflows CLI — drive GoHighLevel CRM and workflows from the terminal (contacts, opportunities, calendars, workflows, conversations, emails, payments, forms, social, locations)"
triggers:
  - salesflow
  - sfw
  - salesflow workflows
  - workflows cli
  - ghl cli
  - ghl contacts
  - ghl workflows
---

# Salesflow Workflows CLI

CLI for the GoHighLevel (GHL) CRM and Marketing API. Manage contacts, pipeline opportunities, calendars, workflows, conversations, emails, payments, forms, social media posts, and locations from the command line or interactive REPL.

Product: [Salesflow One](https://salesflow.one) · Whitelabel app: [app.salesflow.one](https://app.salesflow.one)

## Prerequisites

- Python 3.10+
- `GHL_API_KEY` environment variable set with your GHL API bearer token (Private Integration)
- `GHL_LOCATION_ID` environment variable with your sub-account ID

## Installation

```bash
cd salesflow-workflows-cli
./install.sh
```

## Usage

### CLI Mode (one-shot commands)

```bash
sfw contacts list --json
sfw contacts get <contact_id>
sfw contacts create --email user@example.com --first-name John --last-name Doe
sfw opportunities list --status open
sfw calendars list
sfw workflows list
sfw conversations list --status unread
sfw payments transactions
sfw forms list
sfw social posts
sfw locations get
```

The `ghl` command is a backward-compatible alias for `sfw`.

### REPL Mode (interactive)

```bash
sfw
```

### Global Options

- `--json` — Output as machine-readable JSON (recommended for agents)
- `--location-id <ID>` — Override GHL_LOCATION_ID for this command
- `--experimental` — Enable internal API commands (workflow creation)
- `--version` — Show CLI version
- `--help` — Show help

## Command Groups

| Group | Description | Key Commands |
|-------|-------------|--------------|
| `contacts` | Contact management | list, get, create, update, delete, search, add-tag, remove-tag |
| `opportunities` | Pipeline deals | list, get, create, update, delete, pipelines |
| `calendars` | Scheduling | list, get, slots, appointments, book, groups |
| `workflows` | Automation workflows | list |
| `conversations` | Messaging (SMS, email, chat) | list, get, messages, send |
| `emails` | Email campaigns/templates | list-campaigns |
| `payments` | Financial operations | transactions, orders, invoices, create-invoice |
| `forms` | Form management | list, submissions |
| `social` | Social media posting | accounts, posts, create-post |
| `locations` | Sub-account management | get, search, tags, custom-fields, custom-values |

## Agent Usage Notes

- Always use `--json` flag for programmatic consumption
- Contact search uses `contacts search <query>` for name-based search
- Workflow enrollment is done via `contacts` group (not workflows): the GHL API triggers workflows through contact endpoints
- Social media posting requires OAuth-connected accounts
- All endpoints require valid `GHL_API_KEY` bearer token
- API base URL: `https://services.leadconnectorhq.com`
- API version header: `2021-07-28`
- For workflow **creation**, use `--experimental` and set `GHL_FIREBASE_REFRESH_TOKEN` (grab from Chrome extension on app.salesflow.one)

## Examples

```bash
# List contacts as JSON
sfw --json contacts list --limit 50

# Create a contact with tags
sfw contacts create --email lead@company.com --first-name Jane --last-name Smith --tag "hot-lead" --tag "webinar"

# Search contacts
sfw contacts search "john"

# List pipeline opportunities
sfw --json opportunities list --status open

# Get available calendar slots
sfw calendars slots <calendar_id> --start 2026-03-25 --end 2026-03-30

# Send SMS in conversation
sfw conversations send <conversation_id> --type SMS --message "Thanks for your interest!"

# List transactions
sfw --json payments transactions --limit 50

# Create social post
sfw social create-post --account-id <id> --text "New blog post!" --schedule "2026-03-26T10:00:00Z"
```
