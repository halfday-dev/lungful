import Foundation
import AVFoundation

/// Plays the soft phase tones — the audible twin of the haptic language.
/// Rising tone for inhale, a single strike for the hold, a falling tone for
/// exhale, and nothing on hold-out: silence IS the instruction, same rule as
/// the haptics. Defaults to on — iPads have no haptic engine, so sound is the
/// only non-visual cue there.
///
/// Tones play even when the ring switch is silenced (`.playback` category):
/// the user chose sound in a breathing app, and they mix over other audio
/// rather than interrupting it.
@MainActor
public final class SoundPlayer {

    public static let shared = SoundPlayer()

    static let enabledKey = "lungful.soundEnabled"

    private let defaults: UserDefaults
    private var players: [String: AVAudioPlayer] = [:]
    private var sessionConfigured = false

    /// - Parameter defaults: Backing store for the toggle. Injectable for tests.
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    /// User toggle, persisted. The session screen binds to the same key via
    /// `@AppStorage`, so both views of the flag stay in sync.
    public var isEnabled: Bool {
        get {
            if defaults.object(forKey: Self.enabledKey) == nil { return true }
            return defaults.bool(forKey: Self.enabledKey)
        }
        set { defaults.set(newValue, forKey: Self.enabledKey) }
    }

    // MARK: - Playback

    public func play(_ phase: BreathPhase) {
        switch phase {
        case .inhale:  play(sound: "inhale")
        case .holdIn:  play(sound: "hold")
        case .exhale:  play(sound: "exhale")
        case .holdOut: break  // silence IS the hold
        }
    }

    public func playCompletion() {
        play(sound: "complete")
    }

    // MARK: - Private

    private func play(sound name: String) {
        guard isEnabled else { return }
        configureSessionIfNeeded()

        if players[name] == nil,
           let url = Bundle.module.url(forResource: name, withExtension: "wav"),
           let player = try? AVAudioPlayer(contentsOf: url) {
            player.volume = 0.6
            player.prepareToPlay()
            players[name] = player
        }

        guard let player = players[name] else { return }
        player.currentTime = 0
        player.play()
    }

    private func configureSessionIfNeeded() {
        #if os(iOS)
        guard !sessionConfigured else { return }
        sessionConfigured = true
        try? AVAudioSession.sharedInstance().setCategory(.playback, options: [.mixWithOthers])
        try? AVAudioSession.sharedInstance().setActive(true)
        #endif
    }
}
