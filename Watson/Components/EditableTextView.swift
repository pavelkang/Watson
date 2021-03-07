//
//  EditableTextView.swift
//  Watson
//
//  Created by Kai Kang on 1/1/21.
//  Design inspired by https://blueprintjs.com/docs/#core/components/editable-text
//

import SwiftUI

typealias TOnStringChangeFn = (String) -> Void

class NSEditableTextView: NSTextView {
    private var placeholderInsets = NSEdgeInsets(top: 0.0, left: 4.0, bottom: 0.0, right: 4.0)

    /*
    override func mouseDown(with event: NSEvent) {
        print(event)
    }*/
    
    @objc var placeholderAttributedString: NSAttributedString?
    
    
}


class ScrollableEditableCoordinator: NSObject, NSTextViewDelegate {
    var swiftuiView: _ScrollableEditableTextView
    var onChange: TOnStringChangeFn?
    
    init(_ textView: _ScrollableEditableTextView) {
        self.swiftuiView = textView
        self.onChange = textView.onChange
    }
    
    func textDidChange(_ notification: Notification) {
        if let textField = notification.object as? NSEditableTextView {
            self.swiftuiView.text = textField.string
            if let onChange = self.onChange {
                onChange(textField.string)
            }
        }
    }
    
    func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        switch commandSelector {
        case #selector(NSResponder.insertNewline(_:)):
            if let enterFn = swiftuiView.onEnter {
                /*
                DispatchQueue.main.async { //omg
                      textView.window?.makeFirstResponder(nil)
                  }*/
                enterFn()
            }
            return true
        default:
            return false
        }
    }
    
    
}

struct _ScrollableEditableTextView: NSViewRepresentable {

    var text: String
    var onChange: TOnStringChangeFn?
    var onEnter: (() -> Void)?
    
    var textStyle: NSFont.TextStyle
    var width: CGFloat
    var height: CGFloat
    var isVerticallyResizable: Bool
    var isHorizontallyResizable: Bool
    var maximumNumberOfLines: Int
    var placeholder: String

    
    func makeNSView(context: Context) -> NSScrollView {
        
        
        let scrollView = NSScrollView(frame: NSRect(x: 0, y: 0, width: width, height: height))
        scrollView.drawsBackground = false

        let textView = NSEditableTextView(frame: NSRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height))
        textView.delegate = context.coordinator
        
        textView.font = NSFont.preferredFont(forTextStyle: textStyle)
        textView.isAutomaticTextCompletionEnabled = false
        textView.string = text
        
        textView.drawsBackground = false
        textView.isSelectable = true
        textView.isEditable = true
        textView.placeholderAttributedString = NSAttributedString(string: placeholder)
        // textView.string = text
        textView.maxSize = NSMakeSize(.greatestFiniteMagnitude, .greatestFiniteMagnitude)
        textView.textContainer?.widthTracksTextView = false
        textView.textContainer?.containerSize = NSMakeSize(.greatestFiniteMagnitude, .greatestFiniteMagnitude) // !! Important

        if (isVerticallyResizable) {
            scrollView.hasVerticalScroller = true
            textView.isVerticallyResizable = true
            textView.autoresizingMask = [.height]
            scrollView.autoresizingMask = [.height]
        }
        if (isHorizontallyResizable) {
            scrollView.hasHorizontalScroller = true
            textView.isHorizontallyResizable = true
            textView.autoresizingMask.insert(.width)
            scrollView.autoresizingMask.insert(.width)
        }
        textView.textContainer?.maximumNumberOfLines = maximumNumberOfLines
        // textView.enclosingScrollView?.hasHorizontalScroller = true
        scrollView.documentView = textView
        NotificationCenter.default.addObserver(forName: NSNotification.Name("mousedown_outside"), object: nil, queue: nil, using: {_ in
            textView.window?.makeFirstResponder(nil)
            textView.scroll(NSPoint(x: 0, y: 0))
        })
        
        return scrollView
    }
    
    func updateNSView(_ nsView: NSScrollView, context: Context) {
        print("UPDATE NS VIEW", text)
        if let textView = nsView.documentView as? NSEditableTextView {
            if (text != textView.string) {
                textView.string = text
            }
            // textView.font = NSFont.preferredFont(forTextStyle: textStyle)
        }
    }
    
    func makeCoordinator() -> ScrollableEditableCoordinator {
        ScrollableEditableCoordinator(self)
    }
    
    
    typealias NSViewType = NSScrollView
}

struct EditableTextView: View {
    
    var placeholder: String = ""
    var text: String
    var onChange: TOnStringChangeFn?
    var onEnter: (() -> Void)?
    @State private var hovering: Bool = false
    var width: CGFloat = 400
    var height: CGFloat = 30
    var textStyle: NSFont.TextStyle = .largeTitle
    var isVerticallyResizable: Bool = false
    var isHorizontallyResizable: Bool = true
    var maximumNumberOfLines: Int = 1
    
    var body: some View {
        _ScrollableEditableTextView(text: text, onChange: onChange, onEnter: onEnter, textStyle: textStyle, width: width, height: height, isVerticallyResizable: isVerticallyResizable, isHorizontallyResizable: isHorizontallyResizable, maximumNumberOfLines: maximumNumberOfLines, placeholder: placeholder).frame(width: width, height: height)
            .onHover(perform: { hovering in
                self.hovering = hovering
            })
            .overlay(
                RoundedRectangle(cornerRadius: 3.0)
                    .stroke(Color.SlateGray, lineWidth: hovering ? 1.2 : 0)
            )
    }
}

struct EditableTextArea: View {
    var content: String
    var onChange: TOnStringChangeFn?

    var body: some View {
        EditableTextView(text: content, onChange: onChange, width: 400, height: 200, textStyle: .body, isVerticallyResizable: true, isHorizontallyResizable: true, maximumNumberOfLines: Int(INT_MAX))
    }
    
}

struct EditableTextView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EditableTextView(text: "Add Title Here")
                .frame(width: 500, height: 500)
        }.background(Color.gray)
    }
}
