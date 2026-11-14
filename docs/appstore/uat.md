# lungful 1.0.0 — UAT script

Run on a real iPhone and a real iPad. Delete the app first so it's a fresh install, then press ▶︎ in Xcode.

## A. first launch (iPhone, then iPad)
- [ ] the launch is a smooth dark frame with no white flash, and the icon looks right on the home screen
- [ ] the list header reads "5 patterns · 7 days left in trial"
- [ ] all 5 patterns plus the Custom card show, with no locks

## B. a session: Box Breathing
- [ ] the circle expands on inhale, holds, contracts on exhale, and holds
- [ ] the inhale plays the recorded in-breath
- [ ] the hold-in plays a single strike
- [ ] the exhale plays the recorded out-breath
- [ ] the hold-out is silent
- [ ] haptics feel different on inhale, hold and exhale, and there's none on hold-out (iPhone only; iPads have no haptic engine)
- [ ] hands off for the full session: the screen never dims or locks
- [ ] the end ding plays, the circle settles, and "Complete" shows with Again / Done fading in
- [ ] Again restarts the session; Done returns to the list

## C. sound behaviour
- [ ] with the ring switch on **silent**, the breaths and ding still play
- [ ] with music playing (Spotify or Music), the sounds mix over it and the music doesn't stop
- [ ] the speaker toggle (top-right of the session screen) mutes everything; tap again to unmute
- [ ] mute, force-quit, relaunch: it's still muted. Unmute before continuing
- [ ] on iPad, the sounds are clearly audible (they're the only non-visual cue there)

## D. Dutch Power Breath
- [ ] on first start, the safety alert appears. Accept it
- [ ] the rapid breaths don't pile up: each breath sound cuts off the previous one cleanly
- [ ] the retention "Hold" counts up; Release → 15-second recovery hold → Complete
- [ ] start Dutch Power Breath again: the safety alert does **not** appear

## E. the other patterns
- [ ] 4-7-8, Resonant and Physiological Sigh each run to Complete with the right timing (the duration on each card is about right)

## F. custom builder
- [ ] tap Custom, tap a duration and change it; the preview circle and summary update
- [ ] force-quit, relaunch, open Custom: your values are still there
- [ ] Save to list with a name: it appears on the list
- [ ] force-quit, relaunch: the saved pattern is still there and runs
- [ ] long-press it → delete: it's gone

## G. About screen (≡ top-right)
- [ ] the version reads 1.0.0 (1)
- [ ] the halfday.dev link opens Safari; hello@halfday.dev opens Mail
- [ ] "breath sounds by vikukachannel via Pixabay" shows at the bottom
- [ ] the safety and pricing text reads correctly

## H. iPad layout
- [ ] rotate through all four orientations mid-session: the circle resizes and nothing clips
- [ ] the list and About screen look right in landscape
- [ ] iPhone stays portrait

## I. VoiceOver (Settings → Accessibility → VoiceOver, or triple-click the side button if set up)
- [ ] each pattern card reads as one item: name, duration, description
- [ ] the session controls (speaker, Release, Again, Done) have spoken labels

## J. trial lapse (no code change needed)
1. Settings → General → Date & Time → turn off Set Automatically, then set the date **8 days ahead**
2. Force-quit and relaunch lungful
- [ ] the header reads "2 of 5 patterns free · tap a locked one to unlock"
- [ ] Box Breathing and Physiological Sigh still run
- [ ] 4-7-8, Resonant and Dutch Power Breath are dimmed with a lock
- [ ] the Custom card is locked, and saved custom patterns stay visible but locked
- [ ] tapping any locked card opens the unlock sheet, which shows the price from the App Store (a real price after step K, a placeholder before)
3. Set the date back to automatic

## K. purchase (needs App Store Connect first)
Prerequisites:
- the app record exists in App Store Connect
- the in-app purchase `dev.halfday.lungful.unlock` exists at $4.99
- a sandbox tester exists (Users and Access → Sandbox), and you're signed into it under Settings → App Store → Sandbox Account

- [ ] still lapsed (from J), tap a locked card → Unlock: the sandbox sheet shows $4.99
- [ ] buy it: everything unlocks, the sheet dismisses, and the header no longer mentions the trial
- [ ] force-quit, relaunch: still unlocked
- [ ] delete the app, reinstall, set the date 8 days ahead again, tap a locked card → **Restore Purchases**: everything unlocks
- [ ] cancel the purchase sheet midway: no crash, and it stays locked

## pass bar
A–J must pass before Archive. K must pass before Submit for Review. Report any failure with the step letter.
