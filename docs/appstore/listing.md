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

everything free for 7 days. two patterns free forever. $4.99 once unlocks the rest — no subscription, no account, no data collected. (132 chars)

## description

lungful is a breathing timer. pick a pattern, press begin, and follow a circle that grows and shrinks at the real pace of the breath. each phase lands with its own haptic, so it works with your eyes closed.

the five patterns:

box breathing — 4-4-4-4. steady, good for focus.
4-7-8 — in 4, hold 7, out 8. the classic wind-down.
resonant breathing — 5.5 in, 5.5 out. the slow, even pace people use for heart-rate variability work.
dutch power breath — 30 big breaths, an open hold you release when you're ready, then a recovery breath.
physiological sigh — long inhale, slow exhale. a quick reset.

you can also build your own patterns in half-second steps and save the ones you like.

pricing is simple: everything is free for your first 7 days. after that, box breathing and the physiological sigh stay free forever. $4.99 unlocks everything else, permanently. no subscription.

no accounts, no streaks, no coach voices, no analytics. lungful makes no network calls of its own, which is why the privacy label reads Data Not Collected. your patterns stay on your phone, and the screen stays awake while you breathe.

made by halfday.

## keywords (100 char max)

breathwork,breathing,box breathing,4-7-8,breath hold,resonant,hrv,calm,focus,meditation,sleep,tummo (99 chars)

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
| price | $4.99 (Tier 5) |
| review screenshot | screenshot of the unlock screen (required for IAP review) |

submit the IAP **with** the 1.0.0 app version — first IAP must be reviewed alongside an app binary.

## age rating

4+ — answer "None" for medical/treatment information (lungful is a timer, makes no treatment claims). all other questionnaire answers: None/No.

## URLs

- support URL: https://halfday.dev
- marketing URL (optional): https://halfday.dev
- privacy policy URL (required): **https://halfday.dev/lungful/privacy** — live as of 2026-08-14, legal-reviewed (retention/deletion + third-party language per App Review 5.1.1(i))

## review notes (paste into App Review notes field)

lungful is a breathing timer. it makes no medical or treatment claims; a safety disclaimer is shown before the first retention-hold session (Dutch Power Breath pattern) and on the about screen. the app makes no network calls of its own, has no accounts, and collects no data.

monetization: all features are available free for 7 days after first launch (trial state is stored locally). after the trial, two patterns remain free permanently; a single **non-consumable** in-app purchase ("Full Toolkit", $4.99, one-time — NOT a subscription) unlocks all features permanently. a Restore Purchases button is on the unlock screen, reachable by tapping any locked pattern. no demo account is needed — the app launches into the full-featured trial.
