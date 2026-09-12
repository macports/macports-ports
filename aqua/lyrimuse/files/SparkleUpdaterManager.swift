// MacPorts-only replacement for Sources/lyrimuse/Settings/SparkleUpdaterManager.swift.
//
// An app installed by a package manager must not update itself — `port upgrade`
// is the supported path — so this port drops the Sparkle dependency entirely
// (the same call aqua/Ice makes). Upstream code calls into this manager from
// several places; rather than patching every call site, this stub keeps the
// same surface and does nothing. The updater UI reads `updatesSupported` and
// hides itself.
import Foundation

@MainActor
final class SparkleUpdaterManager: ObservableObject {
    static let shared = SparkleUpdaterManager()

    struct AvailableUpdate: Equatable {
        let version: String
        let releaseNotesURL: URL?
        var downloaded: Bool
    }

    /// Always false in this build: there is no in-app updater.
    static let updatesSupported = false

    @Published private(set) var availableUpdate: AvailableUpdate?
    @Published private(set) var betaFeedURL: URL?

    static var appVersionString: String {
        (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "?"
    }

    var isInstallingUpdate: Bool { false }
    var lastUpdateCheckDate: Date? { nil }

    var automaticallyChecksForUpdates: Bool {
        get { false }
        set { _ = newValue }
    }

    var automaticallyDownloadsUpdates: Bool {
        get { false }
        set { _ = newValue }
    }

    func checkForUpdates() {}

    func betaChannelPreferenceChanged(enabled: Bool) { _ = enabled }

    private init() {}
}
