# Discourse Car Registry

Car registry plugin for TurboRenault Discourse.

## Install

Add the repository to your Discourse `app.yml` plugins section, then rebuild.

```yaml
hooks:
  after_code:
    - exec:
        cd: $home/plugins
        cmd:
          - git clone https://github.com/toejam34/discourse-car-registry.git
```

The public registry is available at `/cars` and the JSON API at `/cars.json`.

## Important

This plugin intentionally uses a Discourse Ember route map for `/cars` and a Rails JSON endpoint for `/cars.json`.
