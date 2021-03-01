//
//  QuickActionBar.swift
//  Watson
//
//  Created by Kai Kang on 12/30/20.
//

import SwiftUI

typealias TypeQAActionFn = (PayloadTrait?) -> Void

/// QuickAction
class QuickAction: Identifiable, Hashable {
    static func == (lhs: QuickAction, rhs: QuickAction) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: String {
        text + "." + identifier
    }
    var text: String
    var symbol: String
    var action: TypeQAActionFn
    var identifier: String
    var payload: PayloadTrait?
    
    init(identifier: String, text: String, symbol: String, action: @escaping TypeQAActionFn) {
        self.text = text
        self.symbol = symbol
        self.action = action
        self.identifier = identifier
    }
    
    init(originalQA: QuickAction, newAction: @escaping TypeQAActionFn) {
        self.text = originalQA.text
        self.symbol = originalQA.symbol
        self.action = newAction
        self.identifier = originalQA.identifier        
    }
    
    // MARK: Factory methods
    static func OpenInBrowserAction(identifier: String, url: String) -> QuickAction {
        QuickAction(identifier: identifier, text: "Open In Browser", symbol: "square.and.arrow.up", action: { _ in
            print("open in browser action")
            if let checkURL = NSURL(string: url) {
                if NSWorkspace.shared.open(checkURL as URL) {
                    print("URL Successfully Opened")
                }
            } else {
                print("Invalid URL", url)
            }
        })
    }
    
    static func CopyToClipBoardAction(identifier: String, content: String) -> QuickAction {
        QuickAction(identifier: identifier, text: "Copy to Clipboard", symbol: "arrow.right.doc.on.clipboard", action: { _ in
            let pasteBoard = NSPasteboard.general
            pasteBoard.clearContents()
            pasteBoard.setString(content, forType: .string)
        })
    }
    
    static func CreateItemAction(identifier: String, item: CheatItem, action: @escaping TypeQAActionFn) -> QuickAction {
        QuickAction(identifier: identifier, text: "Create Item", symbol: "pencil.tip.crop.circle.badge.plus", action: action)
    }
    
    // MARK:Contextualize
    
    /// Contextualize a quick action with the current payload
    func contextualize(payload: PayloadTrait?) -> Void {
        self.payload = payload
    }
    
    func getAction() -> () -> Void {
        return {
            self.action(self.payload)
        }
    }
}

struct QuickActionButtonStyle: ButtonStyle {
    
    var hovering: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        return configuration
            .label
            .font(.title3)
            .frame(width: 30, height: 30, alignment: .center)
            .foregroundColor(hovering ? Color.FloralWhite : Color.blue)//configuration.isPressed ? .gray : .accentColor)
            .background(Circle().foregroundColor(hovering ? .blue : Color.FloralWhite))//Color.FloralWhite))
    }
}

struct QuickActionControl: View {
    
    var quickAction: QuickAction
    var hovering: Bool = false
    
    var body: some View {
        let quickActionText = hovering ? quickAction.text : " "
        HStack(alignment: .bottom) {
            Button(action: quickAction.getAction()) {
                Image(systemName: quickAction.symbol)
            }.buttonStyle(QuickActionButtonStyle(hovering: hovering))
            .onHover(perform: {
                if ($0) {
                    NSCursor.pointingHand.push()
                } else {
                    NSCursor.pointingHand.pop()
                }
            })
            Text(quickActionText).font(.footnote).padding(0)
        }
    }
}

struct QuickActionControlPanel: View {
    
    var quickActionsList: [QuickAction]
    var spacing: CGFloat = 20
    var selectedIndex: Int = 0
    
    var body: some View {
        HStack(alignment: .center, spacing: spacing) {
            ForEach(Array(zip(quickActionsList.indices, quickActionsList)), id: \.1) { index, qa in
                QuickActionControl(quickAction: qa, hovering: index == selectedIndex)
            }
        }
    }
}

struct QuickActionBar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            QuickActionControlPanel(quickActionsList: [
                QuickAction.CopyToClipBoardAction(identifier: "", content: ""),
                QuickAction.OpenInBrowserAction(identifier: "", url: "")
            ])
            QuickActionControl(quickAction: QuickAction.CopyToClipBoardAction(identifier: "", content: ""))
        }
    }
}
