enum BuildUpdatePolicy {
    #if LOCAL_BUILD
        static let allowsApplicationUpdates = false
    #else
        static let allowsApplicationUpdates = true
    #endif
}
