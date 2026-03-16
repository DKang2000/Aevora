# Repo Creation Checklist

## Why this checklist exists
Creating the repo is easy. Creating it without losing product truth is the hard part. This checklist keeps the initial setup clean.

## Create the repo
- create private GitHub repository `aevora`
- protect `main`
- require PRs before merge
- enable branch deletion after merge
- enable discussions only if you actually want them

## Seed the repo with bootstrap files
- copy everything from this bootstrap pack into the repo root
- pin `AGENTS.md` in the repo UI if desired
- import locked foundation docs into `docs/product/`
- add the v1 master build register into `docs/product/`

## Define canonical ownership
- replace CODEOWNERS placeholders
- assign leads for ios, backend, content, art, docs, contracts

## Create baseline labels
- `section-id`
- `ios`
- `backend`
- `content`
- `art`
- `contracts`
- `blocked`
- `needs-adr`
- `v1-only`

## Establish no-drift rules
- all sub-agent work must reference a section ID
- all new specs must live in-repo
- no deliverable may rely on DMs or private chat as its only source

## First docs to commit after bootstrap
- canonical data model
- API contract pack
- event taxonomy contract
- content schema
- entitlements matrix
