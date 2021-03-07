//
//  Suggestion.swift
//  Watson
//
//  Created by Kai Kang on 12/20/20.
//

import Foundation

enum AppType: String {
    case CheatsheetAppType = "Cheatsheet"
    case TodoAppType = "Todo"
}


struct Suggestion: Identifiable, Hashable {
    
    static func == (lhs: Suggestion, rhs: Suggestion) -> Bool {
        return lhs.payload.contentEqual(other: rhs.payload)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: String
    var displayText : String
    var payload: PayloadTrait
    var quickActions: [QuickAction] = []
    
    static func FromExisting(
        payload: PayloadTrait,
        qas: [QuickAction]
    ) -> Suggestion {
        if let ent = payload.originalEnt {
            return Suggestion(
                id: ent.objectID.uriRepresentation().absoluteString,
                displayText: payload.getListViewReadTitle(),
                payload: payload,
                quickActions: qas
            )
        } else {
            print("FromExisting no original ent")
            fatalError()
        }
    }
    
    static func FromNew(
        payload: PayloadTrait,
        qas: [QuickAction]
    ) -> Suggestion {
        return Suggestion(
            id: payload.app.rawValue + "_new",
            displayText: payload.getListViewAddTitle(),
            payload: payload,
            quickActions: qas
        )
    }
    
    func updatePayload(with payload: PayloadTrait) -> Suggestion {
        return Suggestion(id: self.id, displayText: self.displayText, payload: payload, quickActions: self.quickActions)
    }
}

struct SuggestionSection: Identifiable {
    var id: Int
    var name: String
    var sfSymbolName: String
    var suggestions: [Suggestion]
    
    func updateSuggestion(with suggestion: Suggestion) -> SuggestionSection {
        var newSuggestions: [Suggestion] = suggestions
        if let index = suggestions.firstIndex(where:{
            // same id means from the same payload, same ent
            $0.id == suggestion.id
        }) {
            newSuggestions[index] = suggestion
        }
        return SuggestionSection(
            id: self.id,
            name: self.name,
            sfSymbolName: self.sfSymbolName,
            suggestions: newSuggestions
        )
    }
    
}

struct SuggestionResult {
    var content: [SuggestionSection]
    var isEmpty: Bool {
        return content.count == 0
    }
    
    func updateSuggestion(with suggestion: Suggestion) -> SuggestionResult {
        print("update sug", suggestion, suggestion.id)
        return SuggestionResult(content: self.content.map({ section in
            section.updateSuggestion(with: suggestion)
        }))
    }
}
