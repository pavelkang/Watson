//
//  Cheatsheet.swift
//  Watson
//
//  Created by Kai Kang on 12/24/20.
//

import Foundation

struct CheatItem: Hashable, Identifiable, PayloadTrait {
    var app: AppType = AppType.CheatsheetAppType
    
    var name: String?
    var content: String
    init(content: String, name: String? = nil) {
        self.content = content
        self.name = name
    }
    
    var id: String {
        content + "." + (name ?? "")
    }
    
    static func == (lhs: CheatItem, rhs: CheatItem) -> Bool {
        lhs.id == rhs.id
    }
}
