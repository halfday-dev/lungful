# lungful — App Store submission runbook

**date prepared:** 2026-07-18
**prepared by:** claude (unattended session) — all code changes below are **unbuilt**; the sandbox can't run Xcode. step 1 is the real verification gate.

everything that could be done without a Mac + Xcode + Apple Developer account is done. this is the ordered list of what's left, all of it yours.

---

## 0. review what changed

```bash
cd ~/halfday/lungful
git status
git diff
```

new/changed since the 2026-03-28 commit:

| area | files | what |
|---|---|---|
| keep-awake | `Sources/Lungful/Views/BreathSessionView.swift` | screen no longer sleeps mid-session; also adaptive circle sizing (was hardcoded 500pt) |
| safety | same file | one-time alert before first retention-hold (Wim Hof) session |
| persistence | `Sources/Lungful/Models/PatternStore.swift` (new), `CustomPatternView.swift`, `PatternListView.swift` | builder state survives relaunch; "Save to list" puts named customs on the main list (context-menu / long-press to delete) |
| about screen | `Sources/Lungful/Views/AboutView.swift` (new), `PatternListView.swift` | wordmark, version, safety disclaimer, privacy line, halfday.dev link; info glyph top-right of list |
| tests | `Tests/LungfulTests/PatternStoreTests.swift` (new) | 8 tests for the store |
| app shell | `App/` (new), `project.yml` (new) | @main entry, Info.plist config, privacy manifest, icon + launch color assets |
| trial + unlock (added 2026-07-18) | `Sources/Lungful/Models/AccessManager.swift`, `Models/StoreService.swift`, `Views/UnlockView.swift` (all new), `PatternListView.swift` | 7-day full trial → lapses to Box + Physiological Sigh free forever → $2.99 non-consumable IAP unlocks everything. locked cards stay visible and open the unlock sheet |
| store kit | `docs/appstore/` (new) | this folder |

also: delete the stray empty `__test_5` file at repo root (`rm __test_5`).

## 1. build + test (the verification gate)

```bash
cd ~/halfday/lungful
swift test          # expect 71 tests (52 original + 8 PatternStore + 11 AccessManager) passing
```

if anything fails to compile, it'll be in the files above — the changes were written blind. fix or ping claude with the error.

## 2. generate and open the Xcode project

```bash
brew install xcodegen   # once
xcodegen generate
open Lungful.xcodeproj
```

then in Xcode, one-time checks:

- select the Lungful target → Signing & Capabilities → set your **team** (requires Apple Developer Program membership, $99/yr — enroll at developer.apple.com if halfday LLC isn't enrolled yet; LLC enrollment needs a D-U-N-S number, allow a few days)
- confirm bundle id `dev.halfday.lungful` (change in project.yml + regenerate if you want a different one)
- Build Phases → Copy Bundle Resources → confirm `PrivacyInfo.xcprivacy` is listed (add it if XcodeGen didn't)
- run on an iPad simulator AND an iPhone simulator

## 3. on-device sanity pass (TestFlight or direct install)

the checklist that matters, in order of what would embarrass us:

- [ ] fresh install shows "7 days left in trial" and every pattern + the builder works
- [ ] trial lapse: to test without waiting a week, temporarily change `AccessManager.trialLength` to `60` (seconds), relaunch, verify: box + sigh still work, other cards show locks at reduced opacity, saved customs remain visible but locked, tapping any locked card opens the unlock sheet. **change it back to `7 * 86_400` before archiving.**
- [ ] sandbox purchase: with a sandbox Apple ID (App Store Connect → Users and Access → Sandbox Testers), buy the unlock — everything unlocks, sheet dismisses, state survives relaunch
- [ ] Restore Purchases works after deleting + reinstalling (sandbox)
- [ ] screen stays awake through a full coherent breathing session (~2 min hands-off)
- [ ] haptics: distinct medium/rigid/soft per phase, nothing on hold-out, success on completion
- [ ] wim hof: safety alert appears once, never again; retention counts up; Release → 15s recovery → complete
- [ ] custom builder: set a pattern, force-quit, relaunch → values restored
- [ ] save a named pattern → appears on list → survives relaunch → long-press deletes it
- [ ] about screen: version reads 1.0.0 (1), link opens halfday.dev
- [ ] rotate iPad through all orientations mid-session; iPhone stays portrait
- [ ] VoiceOver quick pass: cards read as one element, controls are labeled
- [ ] icon looks right on home screen; launch is a seamless deep-stone frame

## 4. App Store Connect setup

1. appstoreconnect.apple.com → My Apps → **+** → New App: platform iOS, name **lungful** (fallback in `listing.md` if taken), primary language EN, bundle id `dev.halfday.lungful`, SKU `lungful-001`
2. paste everything from **`listing.md`** (description, subtitle, keywords, promo text, categories, age rating, review notes)
3. **create the in-app purchase** — In-App Purchases → **+** → Non-Consumable, all fields from the table in `listing.md` (product id `dev.halfday.lungful.unlock` must match the code exactly), price $2.99, upload the unlock-screen screenshot for IAP review, and attach the IAP to the 1.0.0 version so it's reviewed with the binary
4. App Privacy → answers from **`privacy-labels.md`** (Data Not Collected — the IAP doesn't change this)
5. **publish the privacy policy** from `privacy-policy.md` on halfday.dev and enter its URL (required field — do this before submitting)
6. pricing: app price **Free** (revenue is the IAP)
7. upload screenshots per **`screenshots.md`**
8. before launch: enroll in the **App Store Small Business Program** (15% instead of 30% — applies to IAP revenue too, not retroactive)

## 5. archive, upload, submit

1. Xcode: select "Any iOS Device (arm64)" → Product → Archive
2. Organizer → Distribute App → App Store Connect → Upload (automatic signing)
3. wait for processing (~15 min), then in App Store Connect select the build
4. optional but recommended: TestFlight it to your own devices for a day of real sessions first
5. Submit for Review. typical review time 24-48h. if rejected, the likely asks are the privacy policy URL or a health-claims question — the review notes pre-empt both.

## 6. after approval

- [ ] tag the release in git: `git tag 1.0.0` (halfday convention: no `v` prefix), push
- [ ] halfday.dev product page for lungful (brand guide has the hero treatment: ring + wordmark, bone on deep stone)
- [ ] screenshot the "Data Not Collected" privacy label for marketing

---

*open product questions parked for v1.1: session history (deliberately excluded from v1 — "no streaks" is the positioning), sound cues for eyes-closed sessions, Apple Watch companion, and the AI meditation "composer" idea (see docs/specs/meditation-app-idea.md — separate product decision).*
