# Salesflow Workflows CLI

A command-line interface for driving **GoHighLevel** workflows and CRM operations from the terminal — contacts, opportunities, calendars, conversations, workflows, emails, payments, forms, social media, locations, and documents.

Built by [Salesflow One](https://salesflow.one) for the whitelabel app at [app.salesflow.one](https://app.salesflow.one).

---

## What you get

- **11 command groups** covering the full GHL surface (contacts, opportunities, calendars, workflows, conversations, emails, payments, forms, social, locations, documents).
- **A REPL** — type `sfw` with no args and you get an interactive shell with autocomplete.
- **Workflow builders** — Python utilities in `cli_anything/salesflow_workflows/utils/workflow_builder.py` for creating workflows via the internal API.
- **A Chrome extension** — **Salesflow Workflows Token Grabber** — that grabs the Firebase token you need for workflow creation (the public API is read-only for workflows).
- **A Cursor agent skill** at `cli_anything/salesflow_workflows/skills/SKILL.md` so AI agents can use the CLI on your behalf.

---

## Install

Requirements: **Python 3.10+** and a GoHighLevel sub-account (Salesflow One uses [app.salesflow.one](https://app.salesflow.one)).

```bash
git clone <this repo> salesflow-workflows-cli
cd salesflow-workflows-cli
./install.sh
```

The installer creates a `.venv/`, installs the package, and copies `.env.example` → `.env`.

Open `.env` and fill in:

```env
GHL_API_KEY=pit-xxxxxxxx-...        # GHL Settings → Private Integrations
GHL_LOCATION_ID=YOUR_LOCATION_ID    # the long ID in your GHL URL
```

Smoke test:

```bash
./sfw contacts list --limit 5
```

You should see contacts (or an empty list). The legacy `ghl` command is also available as an alias.

---

## Quickstart examples

```bash
# Contacts
./sfw contacts search --query "jane@"
./sfw contacts create --first-name Jane --last-name Doe --email jane@example.com
./sfw contacts tags add --contact-id <id> --tag trial

# Workflows
./sfw --json workflows list
./sfw workflows enroll --contact-id <id> --workflow-id <id>

# Opportunities
./sfw opportunities list --pipeline-id <id>

# Conversations
./sfw conversations list --contact-id <id>

# REPL (no args = interactive shell with autocomplete)
./sfw
```

`--json` works on most read commands and pipes cleanly into `jq`.

---

## Workflow building (the powerful part)

The public GHL API is read-only for workflows. To **create or update** workflows, the CLI uses GHL's internal API — and that needs a Firebase refresh token.

### Step 1 — grab the token

1. In Chrome, go to `chrome://extensions/` → enable Developer Mode.
2. Click **Load unpacked** → pick the `chrome-extension/` folder in this repo.
3. Open [https://app.salesflow.one](https://app.salesflow.one) while logged in.
4. Click the **Salesflow Workflows Token Grabber** extension → **Grab Refresh Token** → **Copy to Clipboard**.
5. Paste it into your `.env` as `GHL_FIREBASE_REFRESH_TOKEN=...`.

The extension also works on `app.gohighlevel.com` and `*.leadconnectorhq.com` if needed.

### Step 2 — build workflows

Use the experimental workflow commands (requires `--experimental` flag) or write your own builders using `workflow_builder.py` as a reference.

```bash
./sfw --experimental workflows create --help
```

---

## Project layout

```
salesflow-workflows-cli/
├── sfw                         # primary CLI wrapper
├── ghl                         # backward-compatible alias → sfw
├── setup.py                    # package definition
├── install.sh                  # one-shot installer
├── .env.example                # template for your secrets
│
├── cli_anything/
│   └── salesflow_workflows/    # Salesflow Workflows CLI package
│       ├── salesflow_workflows_cli.py
│       ├── utils/              # API clients (public + internal + workflow builder)
│       └── skills/SKILL.md     # Cursor agent skill manifest
│
├── chrome-extension/           # Salesflow Workflows Token Grabber
│   ├── manifest.json
│   ├── popup.html
│   ├── popup.js
│   └── icon48.png
│
└── docs/                       # workflow documentation (add your own)
```

---

## Using it with Cursor / Claude Code

The repo includes an agent skill so AI can call the CLI on your behalf:

1. Copy `cli_anything/salesflow_workflows/skills/SKILL.md` into your agent skills directory (e.g. `~/.cursor/skills/salesflow-workflows-cli/SKILL.md`).
2. Add `sfw` to your shell's PATH (or symlink the `sfw` wrapper somewhere on PATH).
3. In any session, reference the **salesflow-workflows-cli** skill and the agent can run `sfw ...` for you.

---

## Two layers of GHL API

The CLI talks to two APIs:

| API | What it can do | How it authenticates |
|-----|----------------|----------------------|
| **Public** (`services.leadconnectorhq.com`) | Read everything, create contacts/opportunities/etc. **Workflows are GET-only here.** | `GHL_API_KEY` (Private Integration Token) |
| **Internal** (`backend.leadconnectorhq.com`) | Everything the GHL UI can do — including **creating workflows**. Gated behind `--experimental`. | Firebase JWT, refreshed from `GHL_FIREBASE_REFRESH_TOKEN` |

You only need the Firebase token if you want to **build** workflows. Everything else works with just the API key.

If token refresh fails on [app.salesflow.one](https://app.salesflow.one), verify `GHL_FIREBASE_API_KEY` matches your whitelabel app's Firebase project (see `.env.example`).

---

## Security notes

- `.env` is gitignored. **Never** commit it.
- The Firebase refresh token is sensitive (it's your full GHL session). Treat it like a password.
- The bundled Chrome extension only reads from IndexedDB on permitted GHL domains — no network calls.

---

## License

Private / internal use — Salesflow One.
