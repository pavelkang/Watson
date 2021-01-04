//
//  EditableTextView.swift
//  Watson
//
//  Created by Kai Kang on 1/1/21.
//  Design inspired by https://blueprintjs.com/docs/#core/components/editable-text
//

import SwiftUI

class NSEditableTextView: NSTextView {
    private var placeholderInsets = NSEdgeInsets(top: 0.0, left: 4.0, bottom: 0.0, right: 4.0)

    override func mouseDown(with event: NSEvent) {
        print(event)
    }
    
    @objc var placeholderAttributedString: NSAttributedString?
    
    
}


struct _ScrollableEditableTextView: NSViewRepresentable {
    
    var textStyle: NSFont.TextStyle
    var text: String
    
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
        
        
        textView.drawsBackground = false
        textView.isSelectable = true
        textView.isEditable = true
        textView.placeholderAttributedString = NSAttributedString(string: placeholder)
        textView.string = text
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
        if let textView = nsView.documentView as? NSEditableTextView {
            textView.string = text
            textView.font = NSFont.preferredFont(forTextStyle: textStyle)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, NSTextViewDelegate {
        var swiftuiView: _ScrollableEditableTextView
        
        init(_ textView: _ScrollableEditableTextView) {
            self.swiftuiView = textView
        }
        
        func textDidChange(_ notification: Notification) {
        }
        
    }
    
    
    typealias NSViewType = NSScrollView
}

struct EditableTextView: View {
    
    var placeholder: String = ""
    var text: String
    @State private var hovering: Bool = false
    var width: CGFloat = 350
    var height: CGFloat = 30
    var textStyle: NSFont.TextStyle = .largeTitle
    var isVerticallyResizable: Bool = false
    var isHorizontallyResizable: Bool = true
    var maximumNumberOfLines: Int = 1
    
    var body: some View {
        _ScrollableEditableTextView(textStyle: textStyle, text: text, width: width, height: height, isVerticallyResizable: isVerticallyResizable, isHorizontallyResizable: isHorizontallyResizable, maximumNumberOfLines: maximumNumberOfLines, placeholder: placeholder).frame(width: width, height: height)
            .onHover(perform: { hovering in
                self.hovering = hovering
            })
            .overlay(
                RoundedRectangle(cornerRadius: 3.0)
                    .stroke(Color.SlateGray, lineWidth: hovering ? 1.2 : 0)
            )
            // .border(Color.SlateGray, width: hovering ? 1 : 0, cornerRadius: 5.0)
            //.border(Color.SlateGray, width: hovering ? 1 : 0)
    }
}

struct EditableTextArea: View {
    var content: String
    var initialText: String = ""

    var body: some View {
        EditableTextView(text: content, width: 400, height: 200, textStyle: .body, isVerticallyResizable: true, isHorizontallyResizable: true, maximumNumberOfLines: Int(INT_MAX))
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
