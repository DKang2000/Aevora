# iOS CI

## Purpose
Document the canonical validation path for the native Aevora client in GitHub Actions.

## Workflow
- Workflow file: `.github/workflows/ios-ci.yml`
- Runner: `macos-15`
- Project generation: `xcodegen generate --spec ios/project.yml`
- Test command: `xcodebuild test -project ios/Aevora.xcodeproj -scheme Aevora -destination 'platform=iOS Simulator,name=iPhone 17'`

## Inputs
- Xcode available on the hosted macOS runner
- Homebrew availability for installing `xcodegen`
- repo checkout containing `ios/` and `shared/contracts/`

## Artifact outputs
- generated `ios/Aevora.xcodeproj`
- XCTest results from the `Aevora` scheme

## Failure posture
- If project generation fails, the workflow stops immediately.
- If simulator build or tests fail, the workflow fails the pull request or push.
- Signing is intentionally out of scope here and handled by the TestFlight workflow.
