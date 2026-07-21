@main
struct LocalBuildUpdatePolicyTest {
    static func main() {
        #if LOCAL_BUILD
            precondition(
                !BuildUpdatePolicy.allowsApplicationUpdates,
                "LOCAL_BUILD must never contact or run the commercial updater"
            )
            precondition(
                BuildPastePolicy.forcedMethodRawValue == "default",
                "LOCAL_BUILD must force the reliable default paste method"
            )
            precondition(
                !BuildPastePolicy.restoresClipboardAfterPaste,
                "LOCAL_BUILD must not restore stale clipboard content after paste"
            )
        #else
            precondition(
                BuildUpdatePolicy.allowsApplicationUpdates,
                "Official builds must retain the existing updater behavior"
            )
            precondition(
                BuildPastePolicy.forcedMethodRawValue == nil,
                "Official builds must retain the selected paste method"
            )
            precondition(
                BuildPastePolicy.restoresClipboardAfterPaste,
                "Official builds must retain the existing clipboard behavior"
            )
        #endif
    }
}
