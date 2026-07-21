enum BuildUpdatePolicy {
    #if LOCAL_BUILD
        static let allowsApplicationUpdates = false
    #else
        static let allowsApplicationUpdates = true
    #endif
}

enum BuildPastePolicy {
    #if LOCAL_BUILD
        static let forcedMethodRawValue: String? = "default"
        static let restoresClipboardAfterPaste = false
        static let capturesSelectedTextContext = false
    #else
        static let forcedMethodRawValue: String? = nil
        static let restoresClipboardAfterPaste = true
        static let capturesSelectedTextContext = true
    #endif
}
