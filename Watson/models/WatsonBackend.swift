//
//  WatsonBackend.swift
//  Watson
//
//  Created by Kai Kang on 12/27/20.
//

import Foundation

class WatsonApp: Hashable {
    
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    static func == (lhs: WatsonApp, rhs: WatsonApp) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    /// Main entry to get recommendations for a query
    /// - Parameter query: query string
    /// - Returns: A sorted list of suggestion based on descending recommendation priority
    func search(query: String) -> [Suggestion] {
        fatalError("Must override")
    }
    
    
    /// SF Symbol that will be displayed for its section
    var symbol: String {
        fatalError("Must override")
    }
    
}

class WatsonBackend {
    
    var database: Set<Suggestion> = []
    var apps: Set<WatsonApp> = []
    
    init() {
        apps.insert(CheatsheetApp())
        apps.insert(TodoApp())
    }
    
    func search(query: String) -> SuggestionResult {
        var content: [SuggestionSection] = []
        for (index, app) in apps.enumerated() {
            let suggestionsForThisApp: [Suggestion] = app.search(query: query)
            if suggestionsForThisApp.count > 0 {
                content.append(SuggestionSection(id: index, name: app.name, sfSymbolName: app.symbol, suggestions: suggestionsForThisApp))
            }
        }
        return SuggestionResult(content: content)
    }
}
