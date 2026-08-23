# Discourse Car Registry Plugin

A native vehicle and car registry directory plugin for Discourse, built specifically for TurboRenault (migrated from XenForo `FS\\UserCarDetails`).

## Features
- **Public Directory (`/cars`)**: Search and filter by Model, Location, Colour, Registration Plate, Plaque #, and Username.
- **Member Self-Registration**: Members can register and update their cars.
- **Light & Dark Theme Native**: Built-in styling adapting to Discourse color variables and themes.
- **Admin Management**: Manage Car Models and Locations under Discourse Admin.

## Installation

Add to your Discourse container `app.yml`:

```yaml
hooks:
  after_code:
    - exec:
        cd: $home/plugins
        cmd:
          - git clone https://github.com/turborenault/discourse-car-registry.git
```

Rebuild Discourse:
```bash
./launcher rebuild turborenault
```
