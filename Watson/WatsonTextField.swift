//
//  IntegratedTextField.swift
//  Watson
//
//  Created by Kai Kang on 12/27/20.
//

import SwiftUI
import AppKit

struct WatsonTextField: NSViewRepresentable {
    
    @Binding var text: String
    @Binding var textStyle: NSFont.TextStyle
    var onMoveUp: (() -> Void)? = nil
    var onMoveDown: (() -> Void)? = nil
    var onTab: (() -> Void)? = nil
    var onEnter: (() -> Void)? = nil
    var onEsc: (() -> Void)? = nil
    var onControlTextChange: (() -> Void)? = nil
    var onMouseDown: (() -> Void)? = nil
    var focusing: Bool = false
    
    func makeNSView(context: Context) -> TestTextField {
        let textView = TestTextField()
        textView.onMouseDown = onMouseDown
        textView.delegate = context.coordinator
        
        textView.font = NSFont.preferredFont(forTextStyle: textStyle)
        textView.isAutomaticTextCompletionEnabled = false
        textView.isSelectable = true
        textView.drawsBackground = false
        textView.isBezeled = false
        textView.placeholderString = "I'm Watson."
        // wait for next cycle, so field be already in window
        DispatchQueue.main.async {
            NSApplication.shared.windows.first!.makeFirstResponder(textView)
            // textView.window?.makeFirstResponder(textView)
        }
        
        return textView

    }
    
    func updateNSView(_ uiView: TestTextField, context: NSViewRepresentableContext<WatsonTextField>) {
        // uiView.becomeFirstResponder()
        uiView.stringValue = text
        uiView.font = NSFont.preferredFont(forTextStyle: textStyle)
        if uiView.window?.firstResponder == uiView.window {
            // on reload
            uiView.becomeFirstResponder()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
     
    class Coordinator: NSObject, NSTextFieldDelegate {
        var swiftuiView: WatsonTextField
     
        init(_ textField: WatsonTextField) {
            self.swiftuiView = textField
        }
        
        func controlTextDidChange(_ obj: Notification) {
            if let textField = obj.object as? TestTextField {
                self.swiftuiView.text = textField.stringValue
                if let controlTextChangeFn = swiftuiView.onControlTextChange {
                    controlTextChangeFn()
                }
            }
        }
    
        func controlTextDidEndEditing(_ obj: Notification) {
            if let textField = obj.object as? TestTextField {
                print("resign")
                textField.resignFirstResponder()
            }
        }
        
        
        func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
            switch commandSelector {
            case #selector(NSResponder.moveUp(_:)):
                if let moveUpFn = swiftuiView.onMoveUp {
                    moveUpFn()
                }
                return true
            case #selector(NSResponder.moveDown(_:)):
                if let moveDownFn = swiftuiView.onMoveDown {
                    moveDownFn()
                }
                return true
            case #selector(NSResponder.insertNewline(_:)):
                if let enterFn = swiftuiView.onEnter {
                    enterFn()
                }
                return true
            case #selector(NSResponder.insertTab(_:)):
                if let tabFn = swiftuiView.onTab {
                    tabFn()
                }
                return true
            case #selector(NSResponder.cancelOperation(_:)):
                if let escFn = swiftuiView.onEsc {
                    escFn()
                }
                return true
            default:
                print(commandSelector)
                return false
            }
        }
    }
    
    typealias NSViewType = TestTextField
    
}

struct WatsonTextField_Previews: PreviewProvider {
    static var previews: some View {
        WatsonTextField(text: .constant("hello world"), textStyle: .constant(NSFont.TextStyle.largeTitle), onMoveUp: {print("XIXI")})
    }
}
