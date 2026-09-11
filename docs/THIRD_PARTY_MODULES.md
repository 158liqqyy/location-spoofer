# Third-party proxy modules

The third-party proxy modules and recovered WLOC scripts are hosted in this
repository. The original `Yu9191/wloc` repository was deleted, so it is retained
as provenance and is not a runtime dependency.

## Hosted files

- Mirrored module subscriptions: `Resources/ThirdPartyProxyModules/`
- Direct module subscriptions: `ThirdParty/WlocScripts/modules/direct/`
- Versioned recovered scripts: `ThirdParty/WlocScripts/dist/v1/`
- Integrity and runtime tests: `ThirdParty/WlocScripts/test/`

The App appends `?v=1.0.8` to module subscription URLs, and every module uses
the same cache version for its script URLs:

- default mirror:
  `https://gh-proxy.org/https://raw.githubusercontent.com/xweiba/location-spoofer/main/Resources/ThirdPartyProxyModules/<file>?v=1.0.8`
- direct:
  `https://raw.githubusercontent.com/xweiba/location-spoofer/main/ThirdParty/WlocScripts/modules/direct/<file>?v=1.0.8`

| Module file | Client |
|---|---|
| `wloc.module` | Shadowrocket |
| `wloc.sgmodule` | Surge and Egern |
| `wloc.conf` | Quantumult X |
| `wloc.lpx` | Loon |
| `wloc.stoverride` | Stash |

These URLs become downloadable after the change is merged into `main`. Until
then, validate them from the checked-out paths.

## Script protocol

`wloc.js` patches Apple WLOC responses and reads coordinates from the
`wloc_settings` persistent key or module arguments. `wloc-settings.js`
implements `wloc-settings/save` query, clear, and save actions using
`lon`/`lat`/`acc`/`randomRadius` parameters.

The App's third-party save sends WGS-84 `lon`/`lat`/`acc` values. Motion-state
simulation is unavailable in third-party mode; it remains available in App Mode
through the built-in proxy.

## Provenance and maintenance

The prebuilt scripts and license were copied byte-for-byte from the
`xepes0/wloc` community restoration pinned at
`7f28c5e4fb6b802862988735b92e5c800382f2a2`. The recovered original baseline is
`529fcd841952571e79f40faf2d3e0ef90a7bdfa6`. Module metadata keeps the original
author attribution while runtime URLs point to this project.

Full hashes, local differences, regression checks, licensing notes, and the
maintenance exit condition are recorded in
`ThirdParty/WlocScripts/UPSTREAM.md` and
`ThirdParty/WlocScripts/THIRD_PARTY_NOTICES.md`.

Test the scripts with:

```bash
cd ThirdParty/WlocScripts
npm test
```

There is no local rebuild command because the restoration did not recover a
complete reproducible source tree for these prebuilt artifacts.
