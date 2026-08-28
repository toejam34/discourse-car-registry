# TurboRenault Discourse Car Registry

Native vehicle registry for TurboRenault's Discourse forum.

## What it provides

- Public car directory at `/cars`
- Search by username, registration, plaque/build number, project name and notes
- Filter by model and location
- Registered members can add vehicles when `car_registry_allow_all_users_to_add` is enabled
- Owners and administrators can edit/remove entries
- Model/location administration APIs under `/admin/car_models` and `/admin/car_locations`
- Light/dark theme-friendly styling

## Install from GitHub

Add the plugin to the Discourse container's `app.yml` under `hooks.after_code`, or install it through the Discourse plugin configuration used by your deployment:

```yaml
hooks:
  after_code:
    - exec:
        cd: $home/plugins
        cmd:
          - git clone https://github.com/toejam34/discourse-car-registry.git
```

Rebuild the app container:

```bash
./launcher rebuild app
```

Replace `app` with your actual Discourse container name if different.

## API smoke tests

After rebuilding:

```text
https://turborenault.co.uk/cars.json
https://turborenault.co.uk/cars/meta.json
https://turborenault.co.uk/cars
```

`/cars` is the Ember frontend route; `/cars.json` and `/cars/meta.json` are the JSON endpoints.
