//
//  Suggestion.swift
//  Watson
//
//  Created by Kai Kang on 12/20/20.
//

import Foundation

enum AppType {
    case CheatsheetAppType, TodoAppType
}


struct Suggestion: Identifiable, Hashable {
    static func == (lhs: Suggestion, rhs: Suggestion) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: String
    var displayText : String
    var payload: PayloadTrait
    var quickActions: [QuickAction] = []
}

struct SuggestionSection: Identifiable {
    var id: Int
    var name: String
    var sfSymbolName: String
    var suggestions: [Suggestion]
}

struct SuggestionResult {
    var content: [SuggestionSection]
    var isEmpty: Bool {
        return content.count == 0
    }
    
}
