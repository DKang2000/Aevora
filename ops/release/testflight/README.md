# TestFlight Distribution

## Purpose
Document the repo-native path for producing signed iOS archives and uploading them to TestFlight.

## Workflow
- Workflow file: `.github/workflows/testflight.yml`
- Trigger: manual `workflow_dispatch`
- Project generation: `xcodegen generate --spec ios/project.yml`
- Archive command: `xcodebuild archive`
- Export command: `xcodebuild -exportArchive`
- Upload command: `xcrun altool --upload-app`

## Required secrets
- `APP_STORE_CONNECT_ISSUER_ID`
- `APP_STORE_CONNECT_KEY_ID`
- `APP_STORE_CONNECT_PRIVATE_KEY`
- `IOS_DISTRIBUTION_CERT_BASE64`
- `IOS_DISTRIBUTION_CERT_PASSWORD`
- `IOS_PROVISIONING_PROFILE_BASE64`
- `KEYCHAIN_PASSWORD`

## Release notes
- `marketing_version` is supplied at dispatch time.
- `github.run_number` becomes the default build number.
- Internal and beta tester promotion remains an App Store Connect operational step until a later release-management pass automates group assignment.

## Failure and retry notes
- If signing asset import fails, rotate or re-export the certificate and profile bundle.
- If archive succeeds but export fails, check provisioning/profile compatibility first.
- If upload fails, confirm App Store Connect key validity and team permissions before retrying.
