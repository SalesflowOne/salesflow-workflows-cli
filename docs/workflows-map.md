# Workflows Map

> Placeholder for your Salesflow One location workflow inventory.

Document your GoHighLevel workflows here — names, IDs, triggers, and how they connect.

## Generate a live inventory

```bash
./sfw --json workflows list | jq '.workflows[] | {name, id, status}'
```

Save the output to `docs/workflows-live.json` for reference, or maintain this map manually.

## Whitelabel app

Open workflows in the browser at:

`https://app.salesflow.one/location/<GHL_LOCATION_ID>/workflow/<workflow_id>`
