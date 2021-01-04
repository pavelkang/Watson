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
    
    func search(query: String) -> [Suggestion] {
        fatalError("Must override")
    }
    
    var symbol: String {
        fatalError("Must overrid")
    }
    
}

class CheatsheetApp: WatsonApp {
    var databaseForTest: Set<CheatItem> = Set<CheatItem>()
    
    init() {
        super.init(name: "Cheatsheet")
        loadForTest()
    }
    
    func loadForTest() {
        let cheatItemA = CheatItem(content: "Shower him frequently", name: "How to make your puppy prettier")
        let cheatItemB = CheatItem(content: "https://www.nowinstock.net/ca/videogaming/consoles/sonyps5/", name: "Now In Stock: PS5")
        let cheatItemC = CheatItem(content: "Mac Mini is very useful", name: "New Mac Mini Is Here")
        databaseForTest.insert(cheatItemA)
        databaseForTest.insert(cheatItemB)
        databaseForTest.insert(cheatItemC)
    }
    
    func captureIntentToCreate(query: String) -> [Suggestion] {
        let item = CheatItem(content: query)
        return [
            Suggestion(id: self.name + "." + item.id, displayText: "Add " + query, payload: CheatItem(content: query), quickActions: [
                QuickAction.CreateItemAction(
                    identifier: "", item: item,
                    action: {
                        print("Not implemented")
                    })
            ])
        ]
    }
    
    override func search(query: String) -> [Suggestion] {
        return captureIntentToCreate(query: query)
        /*
        let results: Set<CheatItem> = databaseForTest.filter {
            let corpus: String = ($0.name ?? "") + $0.content
            return corpus.lowercased().contains(query.lowercased())
        }
        return results.map { cheatItem -> Suggestion in
            let suggestionId = self.name + "." + cheatItem.id
            return Suggestion(id: suggestionId, displayText: cheatItem.name ?? "", payload: cheatItem, quickActions: [
                QuickAction.OpenInBrowserAction(identifier: cheatItem.id, url: cheatItem.content),
                QuickAction.CopyToClipBoardAction(identifier: cheatItem.id, content: cheatItem.content)
            ])
        }*/

    }
    
    override var symbol: String {
        "books.vertical"
    }
}

class TodoApp: WatsonApp {
    var todoItem: TodoItem?
    
    init() {
        todoItem = nil
        super.init(name: "Todo")
    }
    
    override func search(query: String) -> [Suggestion] {
        return []
    }
    
    override var symbol: String {
        "pencil.tip.crop.circle"
    }
}

class WatsonBackend {
    
    var database: Set<Suggestion> = []
    var apps: Set<WatsonApp> = []
    
    init() {
        apps.insert(CheatsheetApp())
        // apps.insert(TodoApp())
        load()
    }
    
    func load() {
        /*
        let suggestionA = Suggestion(id: 0, displayText: "Healthy Dog Food", cheatItem: CheatItem(id: 0, content: "abc", name: "Healthy Dog Food"))
        let suggestionB = Suggestion(id: 1, displayText: "Border collie guide", cheatItem: CheatItem(id: 1, content: "farmer's dog", name: "Border collie guide"))
        let suggestionC = Suggestion(id: 2, displayText: "Why are Poodles so cute", cheatItem: CheatItem(id: 2, content: "Poodles are very cute!!!", name: "Why are Poodles so cute"))
        database.insert(suggestionA)
        database.insert(suggestionB)
        database.insert(suggestionC)
         */
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
