# Publishing Workflows

This folder holds the manual operator workflows for launch config, content, and asset-manifest promotion.

## Principles
- validate before promote
- keep runtime config and authored content separate
- use guarded admin routes for activation
- treat environment overrides as break-glass, not normal publishing
- keep placeholder-safe asset versioning explicit until the art bundle lands

## Commands
- `corepack pnpm --filter @aevora/api validate:remote-config-release`
- `corepack pnpm --filter @aevora/api validate:content-release`
- `corepack pnpm --filter @aevora/api validate:asset-manifest`

## Workflows
- `ops/publishing/remote-config.md`
- `ops/publishing/content.md`
- `ops/publishing/assets.md`
