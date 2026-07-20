@main
struct LocalBuildUpdatePolicyTest {
    static func main() {
        #if LOCAL_BUILD
            precondition(
                !BuildUpdatePolicy.allowsApplicationUpdates,
                "LOCAL_BUILD must never contact or run the commercial updater"
            )
        #else
            precondition(
                BuildUpdatePolicy.allowsApplicationUpdates,
                "Official builds must retain the existing updater behavior"
            )
        #endif
    }
}
