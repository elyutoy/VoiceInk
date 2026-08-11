import Foundation

@main
struct LocalBuildPolicyTest {
    static func main() {
        #if LOCAL_BUILD
            precondition(
                !BuildUpdatePolicy.allowsApplicationUpdates,
                "LOCAL_BUILD must never start or contact the commercial updater"
            )
            precondition(
                !BuildPastePolicy.restoresClipboardAfterPaste,
                "LOCAL_BUILD must not restore stale clipboard content after paste"
            )
            precondition(
                !BuildPastePolicy.capturesSelectedTextContext,
                "LOCAL_BUILD must not let selected-text capture race with paste delivery"
            )
        #else
            precondition(
                BuildUpdatePolicy.allowsApplicationUpdates,
                "Official builds must retain the updater"
            )
            precondition(
                BuildPastePolicy.restoresClipboardAfterPaste,
                "Official builds must retain clipboard restoration"
            )
            precondition(
                BuildPastePolicy.capturesSelectedTextContext,
                "Official builds must retain selected-text context"
            )
        #endif

        let suiteName = "LocalBuildPolicyTest.\(UUID().uuidString)"
        guard let defaults = UserDefaults(suiteName: suiteName) else {
            preconditionFailure("Could not create isolated UserDefaults suite")
        }
        defer { defaults.removePersistentDomain(forName: suiteName) }

        precondition(
            Set(PasteMethod.allCases.map(\.rawValue)) == Set(["default", "appleScript"]),
            "Both Default and AppleScript must remain selectable"
        )

        PasteMethod.setCurrent(.appleScript, in: defaults)
        precondition(
            PasteMethod.current(in: defaults) == .appleScript,
            "AppleScript selection must persist"
        )

        PasteMethod.setCurrent(.standard, in: defaults)
        precondition(
            PasteMethod.current(in: defaults) == .standard,
            "Default selection must persist"
        )
    }
}
