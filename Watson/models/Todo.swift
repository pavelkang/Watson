//
//  Todo.swift
//  Watson
//
//  Created by Kai Kang on 12/24/20.
//

import Foundation

struct TodoItem: Hashable, Identifiable {
    var content: String
    var done: Bool
    
    init(content: String) {
        self.content = content
        self.done = false
    }
    
    var id: String {
        content
    }
    
    static func == (lhs: TodoItem, rhs: TodoItem) -> Bool {
        lhs.id == rhs.id
    }
}
