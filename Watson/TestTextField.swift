//
//  TestTextField.swift
//  Watson
//
//  Created by Kai Kang on 12/26/20.
//

import AppKit

class TestTextField: NSTextField {
    
    var onMouseDown: (() -> Void)?
    
    override func mouseDown(with event: NSEvent) {
        if let mouseDownFn = onMouseDown {
            mouseDownFn()
        }
        print("mm", event)
    }
    /*
    override func keyDown(with event: NSEvent) {
        print("YO", event.keyCode)
    }
    override func keyUp(with event: NSEvent) {
        print("HI", event.keyCode)
    }
    override func doCommand(by selector: Selector) {
        print(selector)
    }
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        print(event.keyCode)
        if (event.keyCode == 126 || event.keyCode == 125) {
            print("HI")
            return true
        }
        return super.performKeyEquivalent(with: event)
    }*/
}

class TestTextView: NSTextView {
}
