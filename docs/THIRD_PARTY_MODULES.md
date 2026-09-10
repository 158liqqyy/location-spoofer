# Third-party proxy modules

The third-party proxy modules and WLOC scripts are maintained in this
repository. The original `Yu9191/wloc` repository was deleted, and its Raw
URLs now return HTTP 404, so it is retained only as provenance and is not a
runtime dependency.

## Hosted files

- Mirrored module subscriptions: `Resources/ThirdPartyProxyModules/`
- Direct module subscriptions: `ThirdParty/WlocScripts/modules/direct/`
- Versioned generated scripts: `ThirdParty/WlocScripts/dist/v1/`
- Script source and tests: `ThirdParty/WlocScripts/src/` and
  `ThirdParty/WlocScripts/test/`

The App appends `?v=1.0.7` to module subscription URLs, and every module uses
the same query parameter for its generated script URLs, to invalidate client
caches:

- default mirror:
  `https://gh-proxy.org/https://raw.githubusercontent.com/xweiba/location-spoofer/main/Resources/ThirdPartyProxyModules/<file>?v=1.0.7`
- direct:
  `https://raw.githubusercontent.com/xweiba/location-spoofer/main/ThirdParty/WlocScripts/modules/direct/<file>?v=1.0.7`

| Module file | Client |
|---|---|
| `wloc.module` | Shadowrocket |
| `wloc.sgmodule` | Surge and Egern |
| `wloc.conf` | Quantumult X |
| `wloc.lpx` | Loon |
| `wloc.stoverride` | Stash |

The hosted files become downloadable from these URLs after this change is
merged into `main`. Until then, validate them from the checked-out paths.

## Script protocol

`wloc.js` patches Apple WLOC responses and reads coordinates from the
`wloc_settings` persistent key or the module `argument` config.
`wloc-settings.js` implements `wloc-settings/save` (query/clear/save) using
`lon`/`lat`/`acc`/`randomRadius` parameters.

The App's third-party save sends `lon`/`lat`/`acc`. Motion-state simulation
(fields 11/12) is unavailable in third-party mode; it remains available in
App Mode through the built-in proxy.

## Provenance and maintenance

The response-rewrite approach and original module structure were derived from
`Yu9191/wloc`. The repository is no longer available, but its attribution is
preserved in module metadata and project acknowledgements. Bundled dependency
notices are recorded in `ThirdParty/WlocScripts/THIRD_PARTY_NOTICES.md`.

Build and test the scripts with:

```bash
cd ThirdParty/WlocScripts
npm ci
npm test
npm run build
```

If an authoritative, maintained upstream returns, compare its license,
protocol compatibility, tests, and release guarantees before considering a
switch away from the project-owned copies.
