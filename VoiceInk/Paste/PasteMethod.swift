import Foundation

enum PasteMethod: String, CaseIterable, Identifiable {
    case standard = "default"
    case appleScript = "appleScript"

    static let userDefaultsKey = "pasteMethod"
    static let legacyAppleScriptPasteKey = "useAppleScriptPaste"

    var id: String { rawValue }

    static var selectableCases: [PasteMethod] {
        if let forcedMethodRawValue = BuildPastePolicy.forcedMethodRawValue,
            let forcedMethod = PasteMethod(rawValue: forcedMethodRawValue)
        {
            return [forcedMethod]
        }

        return allCases
    }

    var displayName: String {
        switch self {
        case .standard:
            return String(localized: "Default")
        case .appleScript:
            return String(localized: "AppleScript")
        }
    }

    static func current(in defaults: UserDefaults = .standard) -> PasteMethod {
        if let forcedMethodRawValue = BuildPastePolicy.forcedMethodRawValue,
            let forcedMethod = PasteMethod(rawValue: forcedMethodRawValue)
        {
            return forcedMethod
        }

        if let rawValue = defaults.string(forKey: userDefaultsKey),
            let method = PasteMethod(rawValue: rawValue)
        {
            return method
        }

        return defaults.bool(forKey: legacyAppleScriptPasteKey) ? .appleScript : .standard
    }

    static func setCurrent(_ method: PasteMethod, in defaults: UserDefaults = .standard) {
        let effectiveMethod =
            BuildPastePolicy.forcedMethodRawValue.flatMap { PasteMethod(rawValue: $0) } ?? method
        defaults.set(effectiveMethod.rawValue, forKey: userDefaultsKey)
        defaults.set(effectiveMethod == .appleScript, forKey: legacyAppleScriptPasteKey)
    }

    static func migrateLegacyUserDefaultIfNeeded(in defaults: UserDefaults = .standard) {
        if BuildPastePolicy.forcedMethodRawValue != nil {
            setCurrent(.standard, in: defaults)
            return
        }

        if let rawValue = defaults.string(forKey: userDefaultsKey),
            PasteMethod(rawValue: rawValue) != nil
        {
            return
        }

        setCurrent(defaults.bool(forKey: legacyAppleScriptPasteKey) ? .appleScript : .standard, in: defaults)
    }
}
