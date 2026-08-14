# lungful — App Store listing copy

**status:** ready to paste into App Store Connect
**date:** 2026-07-18

---

## app name (30 char max)

**lungful** (7 chars)

if "lungful" is taken as a bare name, fall back to: **lungful — breathwork** (20 chars)

## subtitle (30 char max)

**a breathwork metronome** (22 chars)

## promotional text (170 char max, editable without review)

every pattern free for 7 days. box breathing + the physiological sigh free forever. one $2.99 purchase unlocks the rest — no subscription, no account, no data collected. (166 chars)

## description

lungful is a breathwork metronome. pick a pattern, press begin, and breathe with a circle that expands and contracts at exactly the pace of your breath — with a distinct haptic for each phase, so it works with your eyes closed.

five patterns, each with a reason to exist:

box breathing — 4-4-4-4. the military standard for focus under pressure.
4-7-8 relaxation — dr. andrew weil's slow wind-down pattern.
coherent breathing — 5.5 in, 5.5 out. the pace associated with high heart-rate variability.
wim hof power breath — 30 power breaths, an open-ended retention hold, and a recovery breath.
physiological sigh — a long inhale into a slow exhale. a quick way to settle.

or build your own. set each phase in half-second steps, watch the live preview breathe, and save patterns you want to keep.

everything is free for your first seven days. after that, box breathing and the physiological sigh stay free forever, and a single $2.99 purchase unlocks the full toolkit — every pattern, the builder, and whatever we add next. permanently. no subscription.

what lungful doesn't do: accounts, subscriptions, streaks, coach voices, analytics, or network calls of its own. everything stays on your device. the screen stays awake during a session and the design stays out of your way — earth tones, one circle, your breath.

made by halfday.

## keywords (100 char max)

breathwork,breathing,box breathing,4-7-8,wim hof,coherent,hrv,calm,focus,meditation,sleep (89 chars)

## categories

- primary: Health & Fitness
- secondary: Lifestyle

## pricing

**app price: Free.** monetization is a single non-consumable in-app purchase (decided 2026-07-18 — full-trial-then-unlock model; economics reasoning in `docs/marketing/launch-campaign.md`).

### in-app purchase (configure in App Store Connect → In-App Purchases)

| field | value |
|---|---|
| type | **Non-Consumable** |
| product id | `dev.halfday.lungful.unlock` (must match `StoreService.unlockProductID`) |
| reference name | Lungful Full Toolkit |
| display name (≤30) | Full Toolkit |
| description (≤45) | All patterns, the builder, forever. |
| price | $2.99 (Tier 3) |
| review screenshot | screenshot of the unlock screen (required for IAP review) |

submit the IAP **with** the 1.0.0 app version — first IAP must be reviewed alongside an app binary.

## age rating

4+ — answer "None" for medical/treatment information (lungful is a timer, makes no treatment claims). all other questionnaire answers: None/No.

## URLs

- support URL: https://halfday.dev
- marketing URL (optional): https://halfday.dev
- privacy policy URL (required): publish `privacy-policy.md` at e.g. https://halfday.dev/lungful/privacy — **must be live before submission**

## review notes (paste into App Review notes field)

lungful is a breathing timer. it makes no medical or treatment claims; a safety disclaimer is shown before the first retention-hold session (Wim Hof pattern) and on the about screen. the app makes no network calls of its own, has no accounts, and collects no data.

monetization: all features are available free for 7 days after first launch (trial state is stored locally). after the trial, two patterns remain free permanently; a single **non-consumable** in-app purchase ("Full Toolkit", $2.99, one-time — NOT a subscription) unlocks all features permanently. a Restore Purchases button is on the unlock screen, reachable by tapping any locked pattern. no demo account is needed — the app launches into the full-featured trial.
