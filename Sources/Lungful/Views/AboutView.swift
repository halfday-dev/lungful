import SwiftUI

/// About screen — presented as a sheet from the list menu.
/// Standalone ring + plain wordmark (the ring-as-letter treatment is retired),
/// version, pattern information, how pricing works, tips, safety disclaimer,
/// halfday credit + support contact.
@MainActor
public struct AboutView: View {

    public init() {}

    public var body: some View {
        ZStack {
            Theme.deepStone
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 40) {
                    // Mark + wordmark — standalone ring above plain text
                    VStack(spacing: 20) {
                        BreathRingShape()
                            .fill(Theme.bone)
                            .frame(width: 56, height: 56)

                        VStack(spacing: 10) {
                            LungfulWordmark(size: 40, color: Theme.bone)

                            Text("a breathwork metronome")
                                .font(.system(size: 15, weight: .light, design: .default))
                                .foregroundStyle(Theme.dust)
                        }
                    }
                    .padding(.top, 48)

                    // Version
                    Text(versionString)
                        .font(.system(size: 13, weight: .light, design: .monospaced))
                        .foregroundStyle(Theme.shadow)

                    // The patterns — information section
                    infoCard {
                        Text("the patterns")
                            .font(.system(size: 16, weight: .medium, design: .default))
                            .foregroundStyle(Theme.bone)

                        patternInfo("Box Breathing", "equal 4-counts in, hold, out, hold. the steady classic for focus under pressure.")
                        patternInfo("4-7-8 Relaxation", "the classic wind-down count: in 4, hold 7, out 8.")
                        patternInfo("Resonant Breathing", "5.5 in, 5.5 out — the slow, even pace associated with high heart-rate variability.")
                        patternInfo("Dutch Power Breath", "30 strong breaths, an open-ended retention hold, then a 15-second recovery breath.")
                        patternInfo("Physiological Sigh", "a long inhale into a slow exhale — a quick way to settle.")
                    }

                    // How it works — trial, free forever, one-time unlock
                    infoCard {
                        Text("how it works")
                            .font(.system(size: 16, weight: .medium, design: .default))
                            .foregroundStyle(Theme.bone)

                        Text("everything is free for your first 7 days. after that, Box Breathing and the Physiological Sigh stay free forever. a single one-time purchase unlocks the other three patterns, the custom builder, and saved patterns — permanently. no subscription, no account, nothing recurring.")
                            .font(.system(size: 15, weight: .light, design: .default))
                            .foregroundStyle(Theme.dust)
                            .lineSpacing(4)
                    }

                    // Tips
                    infoCard {
                        Text("tips")
                            .font(.system(size: 16, weight: .medium, design: .default))
                            .foregroundStyle(Theme.bone)

                        Text("each phase lands with its own soft sound and haptic, so sessions work with your eyes closed. the speaker icon on the session screen turns sounds off. the screen stays awake while you breathe — no need to keep tapping it.")
                            .font(.system(size: 15, weight: .light, design: .default))
                            .foregroundStyle(Theme.dust)
                            .lineSpacing(4)
                    }

                    // Safety
                    infoCard {
                        Text("safety")
                            .font(.system(size: 16, weight: .medium, design: .default))
                            .foregroundStyle(Theme.bone)

                        Text("lungful is a breathing timer, not a medical device. breathwork — especially retention holds — can cause dizziness or fainting. never practice retention breathing in water, while driving, or standing up. if you are pregnant or have a heart or respiratory condition, talk to your doctor before practicing.")
                            .font(.system(size: 15, weight: .light, design: .default))
                            .foregroundStyle(Theme.dust)
                            .lineSpacing(4)
                    }

                    // Privacy
                    Text("no accounts. no analytics. no network calls of its own. your patterns stay on this device.")
                        .font(.system(size: 14, weight: .light, design: .default))
                        .foregroundStyle(Theme.dust)
                        .multilineTextAlignment(.center)

                    // Credit + support
                    VStack(spacing: 10) {
                        Link("halfday.dev", destination: URL(string: "https://halfday.dev")!)
                            .font(.system(size: 15, weight: .regular, design: .default))
                            .foregroundStyle(Theme.ochre)

                        Link("hello@halfday.dev", destination: URL(string: "mailto:hello@halfday.dev")!)
                            .font(.system(size: 14, weight: .light, design: .default))
                            .foregroundStyle(Theme.dust)

                        Text("made by halfday")
                            .font(.system(size: 13, weight: .light, design: .default))
                            .foregroundStyle(Theme.shadow)
                            .padding(.top, 4)
                    }
                    .padding(.bottom, 48)
                }
                .frame(maxWidth: 480)
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity)
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Helpers

    @ViewBuilder
    private func infoCard(@ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Theme.warmClay)
                .strokeBorder(Theme.kilnEdge, lineWidth: 1)
        )
    }

    @ViewBuilder
    private func patternInfo(_ name: String, _ detail: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(name)
                .font(.system(size: 15, weight: .medium, design: .default))
                .foregroundStyle(Theme.bone.opacity(0.9))

            Text(detail)
                .font(.system(size: 14, weight: .light, design: .default))
                .foregroundStyle(Theme.dust)
                .lineSpacing(3)
        }
    }

    private var versionString: String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
        return "\(version) (\(build))"
    }
}
