import SwiftUI

/// Single-column list of available breathing patterns — presets, then saved
/// customs, then the create-your-own card. Locked items (post-trial, before
/// unlock) stay visible and open the unlock sheet.
@MainActor
public struct PatternListView: View {
    /// Built-in patterns, excluding the "Custom" placeholder card entry.
    private let presets = BreathPattern.presets.filter { $0.name != "Custom" }

    @ObservedObject private var store = PatternStore.shared
    @ObservedObject private var access = AccessManager.shared
    @Environment(\.scenePhase) private var scenePhase
    @State private var showUnlock = false
    @State private var showAbout = false

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .center) {
                    LungfulWordmark(size: 28, color: Theme.bone)

                    Spacer()

                    // Proper menu — the old bare ⓘ glyph wasn't discoverable
                    // (device feedback 2026-07-21).
                    Menu {
                        Button {
                            showAbout = true
                        } label: {
                            Label("About lungful", systemImage: "info.circle")
                        }

                        if access.access != .unlocked {
                            Button {
                                showUnlock = true
                            } label: {
                                Label("Unlock everything", systemImage: "lock.open")
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.system(size: 18, weight: .light))
                            .foregroundStyle(Theme.dust)
                            .frame(width: 44, height: 44, alignment: .trailing)
                            .contentShape(Rectangle())
                    }
                    .accessibilityLabel("Menu")
                }

                Text(subtitle)
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .foregroundStyle(Theme.shadow)
                    .padding(.leading, 2)
            }
            .frame(maxWidth: 600, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.top, 16)

            LazyVStack(spacing: 20) {
                ForEach(presets) { pattern in
                    patternRow(pattern)
                }

                ForEach(store.savedPatterns) { pattern in
                    patternRow(pattern)
                        .contextMenu {
                            Button(role: .destructive) {
                                store.delete(pattern)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }

                if access.canUseBuilder {
                    NavigationLink(value: "custom") {
                        CustomCard(locked: false)
                    }
                } else {
                    Button {
                        showUnlock = true
                    } label: {
                        CustomCard(locked: true)
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(maxWidth: 600)
            .padding(.horizontal, 24)
            .padding(.top, 16)
        }
        .frame(maxWidth: .infinity)
        .background(Theme.deepStone)
        #if !os(macOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .navigationDestination(for: UUID.self) { id in
            if let pattern = (presets + store.savedPatterns).first(where: { $0.id == id }) {
                BreathSessionView(pattern: pattern)
            }
        }
        .navigationDestination(for: String.self) { value in
            if value == "custom" {
                CustomPatternView()
            }
        }
        .sheet(isPresented: $showUnlock) {
            UnlockView()
        }
        .sheet(isPresented: $showAbout) {
            AboutView()
        }
        .task {
            await StoreService.shared.refresh()
            access.refresh()
        }
        .onAppear {
            access.refresh()
        }
        // Pick up trial-day boundaries (and expiry) when the app comes back
        // to the foreground, not just on view appearance.
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                access.refresh()
            }
        }
    }

    // MARK: - Rows

    @ViewBuilder
    private func patternRow(_ pattern: BreathPattern) -> some View {
        if access.canUse(pattern) {
            NavigationLink(value: pattern.id) {
                PatternCard(pattern: pattern, locked: false)
            }
        } else {
            Button {
                showUnlock = true
            } label: {
                PatternCard(pattern: pattern, locked: true)
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Helpers

    private var subtitle: String {
        let total = presets.count + store.savedPatterns.count
        switch access.access {
        case .unlocked:
            return "\(total) patterns"
        case .trial(let days):
            return "\(total) patterns · \(days) day\(days == 1 ? "" : "s") left in trial"
        case .lapsed:
            let free = presets.filter { access.canUse($0) }.count
            return "\(free) of \(total) patterns free · tap a locked one to unlock"
        }
    }
}

// MARK: - Pattern Card

private struct PatternCard: View {
    let pattern: BreathPattern
    var locked: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Top row: name + lock + duration badge
            HStack(alignment: .top) {
                Text(pattern.name)
                    .font(.system(size: 20, weight: .medium, design: .default))
                    .foregroundStyle(Theme.bone)

                Spacer()

                if locked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundStyle(Theme.shadow)
                        .padding(.top, 5)
                }

                // Duration badge
                Text(formattedDuration(pattern.totalDuration))
                    .font(.system(size: 12, weight: .regular, design: .monospaced))
                    .foregroundStyle(Theme.shadow)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Theme.kilnEdge)
                    )
            }

            Text(pattern.description)
                .font(.system(size: 15, weight: .light, design: .default))
                .foregroundStyle(Theme.dust)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            // Phase indicator strip
            PhaseStrip(pattern: pattern)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Theme.warmClay)
                .strokeBorder(Theme.kilnEdge, lineWidth: 1)
        )
        .opacity(locked ? 0.55 : 1.0)
        .accessibilityElement(children: .combine)
        .accessibilityHint(locked ? "Locked. Opens the unlock screen." : "")
    }

    private func formattedDuration(_ seconds: TimeInterval) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        if mins == 0 { return "\(secs)s" }
        if secs == 0 { return "\(mins)m" }
        return "\(mins)m \(secs)s"
    }
}

// MARK: - Phase Indicator Strip

private struct PhaseStrip: View {
    let pattern: BreathPattern

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                let total = pattern.cycleDuration
                if total > 0 {
                    if pattern.inhaleDuration > 0 {
                        Theme.sage
                            .frame(width: geometry.size.width * pattern.inhaleDuration / total)
                    }
                    if pattern.holdInDuration > 0 {
                        Theme.amber
                            .frame(width: geometry.size.width * pattern.holdInDuration / total)
                    }
                    if pattern.exhaleDuration > 0 {
                        Theme.terracotta
                            .frame(width: geometry.size.width * pattern.exhaleDuration / total)
                    }
                    if pattern.holdOutDuration > 0 {
                        Theme.slate
                            .frame(width: geometry.size.width * pattern.holdOutDuration / total)
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 2, style: .continuous))
        }
        .frame(height: 4)
    }
}

// MARK: - Custom Card

private struct CustomCard: View {
    var locked: Bool = false

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: locked ? "lock.fill" : "plus")
                .font(.system(size: 24, weight: .light))
                .foregroundStyle(locked ? Theme.shadow : Theme.ochre)

            Text("Custom")
                .font(.system(size: 15, weight: .light, design: .default))
                .foregroundStyle(Theme.dust)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(
                    locked ? Theme.shadow : Theme.ochre,
                    style: StrokeStyle(lineWidth: 1, dash: [6, 4])
                )
        )
        .opacity(locked ? 0.7 : 1.0)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(locked ? "Custom pattern builder. Locked. Opens the unlock screen." : "Create custom pattern")
    }
}
