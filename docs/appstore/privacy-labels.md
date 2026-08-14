# lungful — App Store Connect privacy answers

**status:** ready to enter in App Store Connect → App Privacy
**date:** 2026-07-18

---

## the answer

**Data Not Collected.**

when App Store Connect asks "Do you or your third-party partners collect data from this app?" answer **No**.

this is true, and it must stay true:

- no network calls of lungful's own anywhere in the codebase. two things touch the network and neither is data collection by us: the halfday.dev link on the about screen (opens in the browser), and **StoreKit** (the $4.99 unlock purchase — Apple's own commerce system, processed under Apple's privacy policy, invisible to us). "Data Not Collected" remains the correct answer with the IAP; purchases via StoreKit do not require any privacy-label disclosure by the developer when no other data is collected.
- no analytics or crash-reporting SDKs
- no third-party SDKs at all (pure SwiftUI, zero dependencies)
- no accounts, no identifiers
- saved patterns and preferences live in UserDefaults on-device and never leave

## privacy manifest

`App/PrivacyInfo.xcprivacy` declares:

- tracking: none, tracking domains: none
- collected data types: none
- accessed API categories: UserDefaults, reason `CA92.1` (app's own preferences — saved patterns, builder state, safety-note flag)

if you ever add an API from Apple's "required reasons" list (file timestamps, boot time, disk space, keyboards), add the reason code here or App Store validation will reject the build.

## the label shown to users

the store listing will display **"Data Not Collected"** — worth screenshotting for marketing. almost nothing else in the breathwork category has it.
