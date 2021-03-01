//
//  CheatItemEnt+CoreDataClass.swift
//  Watson
//
//  Created by Kai Kang on 2/22/21.
//
//

import Foundation
import CoreData

@objc(CheatItemEnt)
public class CheatItemEnt: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CheatItemEnt> {
        return NSFetchRequest<CheatItemEnt>(entityName: "CheatItemEnt")
    }

    @NSManaged public var content: String
    @NSManaged public var title: String?

    var app: AppType = AppType.CheatsheetAppType
    
}

struct CheatItem: PayloadTrait, Hashable {
    mutating func set(key: String, with value: Any?) {
        switch key {
        case "title":
            self.title = value as! String
        case "content":
            self.content = value as! String
        default:
            print("ERROR", key, value)
        }
    }
    
    func get(key: String) -> Any? {
        switch key {
        case "title":
            return self.title
        case "content":
            return self.content
        default:
            print("ERROR", key)
            return ""
        }
    }
    
    
    var app: AppType = AppType.CheatsheetAppType
    
    var content: String
    var title: String
    
    var id: String {
        title + content
    }
    
    init(content: String) {
        self.title = ""
        self.content = content
    }
    
    init(content: String, title: String) {
        self.title = title
        self.content = content
    }
    
    init(fromEnt ent: CheatItemEnt) {
        self.title = ent.title ?? ""
        self.content = ent.content
    }
}
