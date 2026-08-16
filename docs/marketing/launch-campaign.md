# lungful launch campaign

**date:** 2026-07-18
**status:** ready — calendar is keyed to App Store approval day ("day 0"), not calendar dates
**scale honesty:** this is a solo-founder, $0-paid-budget launch on a site with ~10 real pageviews/30d. the plan is sized for that. no enterprise cosplay.

---

## 1. overview

**campaign name:** lungful launch ("the metronome")

**one sentence:** launch lungful on the App Store with the same motion that worked for rune — an honest product page + blog post on halfday.dev, then a one-day push to HN and reddit — positioned against subscription-fatigue in the breathwork category.

**primary objective (updated 2026-07-18 for the trial/unlock model):** 1,000 installs and 40 unlocks (~$170 net at the Small Business Program's 15% rate) in the first 30 days after approval. installs are the funnel metric, unlocks are the money metric — track both.

**secondary objectives:** halfday.dev uniques break the 54–115/day baseline band on launch day; lungful product page becomes the second-most-visited page on the site; one piece of earned commentary (HN front page not required — a real comment thread is the win).

## 2. audience

**primary:** people who already practice breathwork (box, 4-7-8, retention work) and are annoyed by their current app — the calm/headspace refugee. they know the techniques; they need a timer, not a course. found in: r/breathwork, r/Wim_Hof, r/Meditation, HN (huge overlap with "I hate subscriptions" energy).

**secondary:** the privacy-conscious buyer — the same person who reads halfday's rune content. "Data Not Collected" + no network is a real differentiator they'll pay $4.99 to vote for.

**pain points:** subscription fatigue ($70/yr for pre-recorded audio), account walls before first breath, streaks/gamification in a calm app, apps that feel like fintech dashboards.

**buying stage:** decision. these people search "box breathing timer" already. the job is to be findable and obviously different.

## 3. key messages

**core:** lungful is a breathwork metronome — five proven patterns and your own, on a timer that feels like a well-made tool. free for a week, two patterns free forever, $4.99 once for everything. no account. no subscription. no data collected.

**model (decided 2026-07-18):** 7-day full-featured trial → lapses to box breathing + physiological sigh free forever → $4.99 non-consumable IAP unlocks the full toolkit permanently. rationale: the whole app is the demo (conversion driven by formed habit, not annoyance), a real free tier keeps ratings/word-of-mouth alive, and StoreKit doesn't touch the Data Not Collected label. free-with-ads was evaluated and rejected — at our scale ads earn ~$10-40/mo and destroy the privacy positioning. full comparison lives in this doc's history + the 2026-07-18 session notes.

**supporting:**
1. *the metronome, not the composer* — breathing techniques are old and public. you don't need content, you need time kept precisely. (proof: five patterns with real lineage, described generically in-app — named-person and trademarked branding removed 2026-08-14 for IP hygiene; editorial references in the blog stay nominative.)
2. *works with your eyes closed* — distinct haptic per phase; the screen stays awake; the circle moves at exactly the pace of your breath. (proof: the haptic language table, breath-matched animation.)
3. *privacy isn't a feature, it's the architecture* — no network calls, no SDKs, "Data Not Collected" on the store label. (proof: screenshot the privacy label itself.)
4. *pay once, if ever* — free trial of everything, two patterns free forever, $4.99 one time for the rest. no trial that converts to $69.99/yr. (proof: the pricing screen fits in one sentence.)

**tone by channel:** blog = halfday voice (lowercase, honest, concrete). HN = engineering-forward, lead with "no network, pure SwiftUI, pay-once" and the design constraints. reddit = community-member-first, lead with the technique support (retention hold with count-up timer), mention it's yours once, in comments.

## 4. channels

all owned/earned, $0 paid. effort levels for one person.

| channel | why | format | effort |
|---|---|---|---|
| App Store product page | the actual conversion surface; most traffic converts or dies here | listing.md copy + 10 screenshots (already done) | done |
| halfday.dev blog | the story lives here; everything else links to it | announcement post (drafted, `draft: true` in env-validator) | low |
| halfday.dev product page | /products/lungful, sibling of /products/rune | astro page, brand-guide hero (ring + wordmark on deep stone) | medium |
| Show HN | proven halfday channel; pay-once/no-data angle is HN catnip | link to blog post, not the store; author comment ready | low |
| reddit (r/breathwork, r/Wim_Hof) | exact-audience communities; retention-hold feature is genuinely relevant to r/Wim_Hof | native posts, not link drops; check each sub's self-promo rules first | low-medium |
| App Store search (ASO) | "box breathing timer", "breathing app no subscription" | keywords field (done); iterate post-launch on what converts | low |

**deliberately skipped:** paid ads (wrong economics at $4.99), influencer outreach (no leverage yet), Product Hunt (optional wave-2 experiment if launch week goes well — don't split launch-day attention), press (no story yet; "solo dev ships breathing app" isn't coverage, 1,000 downloads might be).

## 5. calendar (keyed to approval day = day 0)

| when | piece | channel | notes |
|---|---|---|---|
| now | announcement blog post | halfday.dev | drafted at `env-validator/src/content/blog/lungful-a-breathwork-metronome.md`, `draft: true`; set real date + App Store URL at publish |
| now → submission | product page /products/lungful | halfday.dev | build from rune.astro pattern; needs 2-3 of the same screenshots from the submission set |
| submission day | (nothing public) | — | app in review; don't pre-announce, review can bounce |
| day 0 (approval) | flip post `draft: false`, set date, insert store link; deploy; verify live | halfday.dev | deploy = push to main, per halfday_dev_release_ops runbook |
| day 0 or next weekday morning | Show HN | HN | 9-11am ET tues-thurs is the good window; post the blog URL; first comment = the technical story (draft in §6) |
| day 0/+1 | r/Wim_Hof post | reddit | lead with the retention-hold count-up feature |
| day +1/+2 | r/breathwork post | reddit | broader "metronome not composer" angle |
| day +7 | check-in: downloads, ASO keyword iteration, decide on Product Hunt + build-story post | — | |
| day +14 | optional: "how it's built" post (pure SwiftUI, no deps, the design review saga, built with AI agents) | halfday.dev / HN | rune's second post pattern; only if there's appetite |

**dependency chain:** privacy policy live on halfday.dev → submission → approval → blog post live → HN/reddit link to it. don't break the chain by announcing before the store page exists.

## 6. content pieces

| piece | status | priority |
|---|---|---|
| App Store listing + screenshots plan | **done** (`docs/appstore/`) | must |
| announcement blog post | **drafted** (this campaign) | must |
| privacy policy page | text done, needs publishing | must (submission blocker) |
| /products/lungful page | to build — say the word and I'll draft the .astro file | must |
| Show HN title + first comment | draft below | must |
| 2 reddit posts | draft on launch week (want fresh sub-rule check first) | should |
| "how it's built" post | outline only, day +14 decision | nice |

**Show HN draft (edit to taste):**
> **title:** Show HN: Lungful – a breathwork metronome (no subscription, no accounts, no data)
>
> **first comment:** I built this because every breathing app I tried wanted an account, a subscription, and a streak before letting me breathe for four minutes. Lungful is the opposite bet: the techniques (box, 4-7-8, resonant, power-breath retention, physiological sigh) are old and public — what you need is a precise timer. Pure SwiftUI, zero dependencies, no network calls of its own, so the App Store privacy label is "Data Not Collected." The circle animates at exactly the pace of each breath phase with a distinct haptic per phase, so it works eyes-closed. The Dutch Power Breath mode has an open-ended retention hold that counts up until you release it. Pricing is the whole model in one sentence: everything free for 7 days, two patterns free forever, $4.99 once unlocks the rest — no subscription. (Yes, the trial resets if you reinstall. At $4.99 I'm not building infrastructure to fight that.) Happy to answer anything about the design system or the economics.

## 7. metrics

| metric | target | source | cadence |
|---|---|---|---|
| installs (funnel) | 1,000 in 30 days | App Store Connect | weekly |
| unlocks (money, primary) | 40 in 30 days (~4% of installs) | App Store Connect | weekly |
| launch-day site uniques | break the 54–115 baseline band | Cloudflare Web Analytics (trust this, not zone stats) | launch day |
| product-page views | 200 in launch week | Web Analytics | weekly |
| HN result | a real comment thread (>10 comments) | HN | launch day |
| App Store page conversion | ≥5% product-page-view → purchase | App Store Connect | day +14, then iterate ASO |

no new analytics infra — everything above is already measurable. log results in the vault's `halfday_analytics/traffic_log` like the rune baseline.

## 8. budget

$0 media. real costs already sunk or committed: Apple Developer $99/yr, T's time. **one action item with money attached:** after the paid app is set up, enroll in the **App Store Small Business Program** (developer.apple.com → reduces Apple's cut from 30% to 15% under $1M/yr — that's $4.24 vs $3.49 per copy; it does not apply retroactively, so do it before launch).

## 9. risks

1. **app review rejection** (health-adjacent app) → mitigated: review notes pre-empt it, disclaimer shipped, no medical claims anywhere. if rejected, fix and resubmit — costs days, not the campaign; nothing is announced until approval.
2. **HN indifference** (one shot, timing-sensitive) → mitigated: HN is upside, not the plan. the durable channels are App Store search + the two subreddits. a flopped Show HN can be re-posted once after a substantial update (v1.1).
3. **reddit self-promo removal** → mitigated: read each sub's rules the week of; post as a practitioner sharing a tool, put the link in comments if rules require; r/Wim_Hof post leads with the feature their technique actually needs.
4. **name collision on the store** ("lungful" taken) → fallback name in listing.md; check the moment App Store Connect app creation happens (step 4 of the runbook).

## 10. next steps

1. T: work the submission runbook (the campaign has no start date until the app is approved).
2. claude, on request: draft `/products/lungful.astro` from the rune page pattern; draft the reddit posts launch week.
3. at approval: flip the blog post live, deploy, then the §5 sequence.
