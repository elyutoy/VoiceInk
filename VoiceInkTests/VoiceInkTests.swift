//
//  VoiceInkTests.swift
//  VoiceInkTests
//
//  Created by Prakash Joshi on 15/10/2024.
//

import AppKit
import Testing
@testable import VoiceInk

struct VoiceInkTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }

    @Test @MainActor
    func pasteSessionReassertsFreshTranscriptionBeforePostingCommand() async {
        let defaults = UserDefaults.standard
        let previousRestoreClipboard = defaults.bool(forKey: "restoreClipboardAfterPaste")
        let previousPasteMethod = PasteMethod.current(in: defaults)
        let pasteboard = NSPasteboard.general
        let previousClipboardText = pasteboard.string(forType: .string)

        defaults.set(false, forKey: "restoreClipboardAfterPaste")
        PasteMethod.setCurrent(.standard, in: defaults)

        let competingClipboardWrite = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 50_000_000)
            _ = ClipboardManager.setClipboard("stale clipboard value")
        }

        _ = await CursorPaster.pasteAtCursorAndWaitUntilPosted("fresh transcription")
        await competingClipboardWrite.value

        #expect(pasteboard.string(forType: .string) == "fresh transcription")

        defaults.set(previousRestoreClipboard, forKey: "restoreClipboardAfterPaste")
        PasteMethod.setCurrent(previousPasteMethod, in: defaults)
        pasteboard.clearContents()
        if let previousClipboardText {
            pasteboard.setString(previousClipboardText, forType: .string)
        }
    }

}
