---
name: deploy-eas
description: Build, update, and submit Expo or React Native apps safely with EAS Build, EAS Update, and EAS Submit. Use for preview or production mobile builds, TestFlight, Google Play tracks, App Store uploads, OTA updates, eas.json profiles, or when the ship workflow resolves EAS as the deployment target.
---

# Deploy with EAS

Keep building, store submission, and OTA publication as separate actions. Never let a convenient flag blur their approval boundaries.

## Credentials

- Use an existing Expo login or an `EXPO_TOKEN` already exported into the process environment.
- Never print tokens, read Expo credential files into model context, or commit signing material.
- If authentication is missing, ask the user to authenticate outside the agent session and retry.
- Treat signing-credential creation, replacement, or revocation as an external side effect that requires explicit confirmation.

## Resolve the Release Contract

1. Read the applicable `AGENTS.md`, `package.json`, Expo app config, `eas.json`, update configuration, and current git state.
2. Classify the requested action:
   - Local native build or cloud build
   - Internal preview build or production binary
   - Store upload through EAS Submit
   - Preview or production OTA update
3. Resolve the platform, explicit build and submit profiles, distribution type, application identifiers, version and build number policy, EAS environment, update channel, runtime version, and destination store track.
4. Never rely on EAS defaults for a release action. Pass the intended platform and profile explicitly.

## Verify Before Release

1. Run the full check workflow.
2. Confirm the working tree and commit being released.
3. Confirm that the selected profile uses the intended identifiers, environment, distribution, and update channel without exposing secret values.
4. For OTA updates, verify native runtime compatibility. Native dependency or app-config changes require a new binary, not merely an update.

## Build

- Use `eas build --local` only when the local platform and toolchain support the requested build; local builds still require Expo authentication and may not receive secret EAS environment variables.
- Before any cloud build, state the platform, profile, commit, distribution, expected cost or quota use, and whether submission follows. Obtain explicit confirmation when it may cost money or targets production.
- Run `eas build --platform <android|ios|all> --profile <profile>` without `--auto-submit` unless store submission has been separately approved.
- Monitor the build to completion. On failure, inspect logs and fix the cause instead of blind-retrying.

## Submit

1. State the exact platform, build ID or artifact, submit profile, and destination track or TestFlight behavior.
2. Obtain explicit confirmation immediately before every `eas submit`, `eas build:submit`, or `--auto-submit` action. An app-store upload always crosses the confirmation boundary, even when it is not a public release.
3. Prefer an explicit build ID over an ambiguous "latest" build for production submissions.
4. Monitor submission processing and report the dashboard URL and result. Do not claim an iOS App Store release merely because the build reached TestFlight.

## Publish an OTA Update

1. Verify the exact tested commit, environment, channel, message, and runtime version.
2. Test on the preview or staging channel first when available.
3. Obtain explicit confirmation immediately before publishing to a production channel.
4. Publish with an explicit channel and environment, then install or reload the matching build and verify the update.

## Record the Result

Update the project deployment notes with the EAS project, profiles, channels, store tracks, build or submission IDs, URLs, and verification result. Never store credentials.

EAS CLI behavior changes over time. Check Context7 first for current Expo documentation, then fall back to the official Expo docs when Context7 is unavailable.
