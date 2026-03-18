# Unicorns

A demo iOS app built with [ios-deploy-kit](https://github.com/igobymike/ios-deploy-kit) to showcase the full pipeline.

```
git push  →  GitHub builds .ipa  →  phone buzzes  →  tap to install
```

## What It Is

A SwiftUI unicorn gallery with 12 unicorns, stats, favorites, element filters, animated detail views with floating sparkle particles, and a compendium tab. It's deliberately over-the-top — the point is to prove the pipeline works with a real app, not just a "Hello World."

## How It Was Made

```bash
python3 ~/ios-deploy-kit/scripts/create-app.py \
  --name Unicorns \
  --bundle-id com.baiteks.Unicorns \
  --display-name "Unicorns" \
  --output-dir ~/unicorns-ios
```

That command scaffolded the entire project, created this GitHub repo, set all signing secrets, and pushed the first commit. The only manual step was writing the actual app code in `ContentView.swift`.

## The App

| Tab | What |
|-----|------|
| **Gallery** | 2-column grid with element filter chips (Cosmic, Fire, Ice, Nature, Shadow, Light) |
| **Favorites** | Heart any unicorn to save it here |
| **Compendium** | Stats dashboard, element distribution, sortable list |

Each unicorn has:
- Unique stats (Power, Speed, Magic, Defense) with animated bars
- Rarity tier (Common / Rare / Epic / Legendary)
- Element type with gradient theming
- Special ability description
- Expandable lore section
- Floating sparkle particle effects on the detail view

## Pipeline

Built and deployed via GitHub Actions → OTA:

1. Push to `master`
2. GitHub macOS runner builds + signs the `.ipa` (~40s)
3. Webhook fires to the deploy server
4. Server stages the IPA for OTA install
5. APNs push notification sent to registered devices
6. Tap notification → iOS installs the app

No Mac needed. No Xcode. No TestFlight.

## License

MIT
