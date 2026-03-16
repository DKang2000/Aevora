# Backend CI

This directory documents the backend validation and release pipeline foundations.

## Current gate
- install workspace dependencies
- typecheck backend packages
- run backend and analytics tests
- validate Prisma schema
- validate analytics fixtures and demo datasets

## Future extension
- staging deploy promotion
- migration apply step gated behind manual approval
- production rollout orchestration
