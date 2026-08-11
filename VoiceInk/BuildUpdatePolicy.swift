enum BuildUpdatePolicy {
    #if LOCAL_BUILD
        static let allowsApplicationUpdates = false
    #else
        static let allowsApplicationUpdates = true
    #endif
}

enum BuildPastePolicy {
    #if LOCAL_BUILD
        static let restoresClipboardAfterPaste = false
        static let capturesSelectedTextContext = false
    #else
        static let restoresClipboardAfterPaste = true
        static let capturesSelectedTextContext = true
    #endif
}
