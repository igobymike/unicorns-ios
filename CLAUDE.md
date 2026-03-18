# CLAUDE.md — Agent Instructions for Unicorns

**STOP. Read this file completely before writing any code.**

This app was built with [ios-deploy-kit](https://github.com/igobymike/ios-deploy-kit). The kit handles CI/CD, code signing, OTA deployment, and push notifications. Do NOT improvise any of that infrastructure.

---

## Mandatory Reading

Before doing any work, read the full agent guide:
```bash
cat ~/ios-deploy-kit/AGENT.md
```

That file has the complete rules, architecture diagram, build error fixes, and credential references. Everything below is a summary.

---

## Critical Rules

1. **You do NOT need a Mac.** GitHub Actions provides macOS runners.
2. **Do NOT manually edit `project.pbxproj`.** Use `add-file.py`:
   ```bash
   python3 ~/ios-deploy-kit/scripts/add-file.py \
     --project Unicorns/Unicorns.xcodeproj/project.pbxproj \
     --source-root Unicorns/Unicorns \
     --scan
   ```
3. **Use Tailscale** (`100.71.157.108`) for server communication. Do NOT create Cloudflare tunnel routes.
4. **All apps share ONE deploy webhook** at `marcus.baiteks.com/api/deploy` (port 9879). Do NOT create new webhook instances.
5. **OTA files go in `~/marcus-ios/.deploys/ota/`** — the webhook auto-serves them.
6. **Do NOT add App Groups or Share Extensions** in the initial build (requires Apple portal registration first).

## SwiftUI Gotchas

- `.foregroundStyle(.accentColor)` **won't compile** — use `.foregroundStyle(Color.accentColor)`
- `Section("Title") { } footer: { }` **won't compile** — use `Section { } header: { Text("Title") } footer: { }`

## This App

| Item | Value |
|------|-------|
| App Name | Unicorns |
| Bundle ID | com.baiteks.Unicorns |
| GitHub Repo | igobymike/unicorns-ios |
| Install URL | `https://marcus.baiteks.com/api/deploy/unicorns-install` |

## Workflow: Adding Code

1. Write your `.swift` files
2. Register them: `python3 ~/ios-deploy-kit/scripts/add-file.py --project Unicorns/Unicorns.xcodeproj/project.pbxproj --source-root Unicorns/Unicorns --scan`
3. Commit and push to `main`
4. GitHub Actions builds and signs the IPA
5. Webhook stages OTA files and sends push notification
6. Download artifact and stage: `gh run download <RUN_ID> --repo igobymike/unicorns-ios`
7. Copy IPA to `~/marcus-ios/.deploys/ota/Unicorns.ipa`
8. Verify: `curl -s -o /dev/null -w "%{http_code}" https://marcus.baiteks.com/api/deploy/unicorns-install`

## Full Reference

All credentials, existing apps, error fixes, and architecture details are in:
```bash
cat ~/ios-deploy-kit/AGENT.md
```
