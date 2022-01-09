//
//  TodoApp.swift
//  Watson
//
//  Created by Kai Kang on 3/19/21.
//

import Foundation

class TodoApp: WatsonApp {

    init() {
        super.init(name: "Todo")
    }
    
    override func search(query: String) -> [Suggestion] {
        return []
    }
    
    override var symbol: String {
        "pencil.tip.crop.circle"
    }

}
