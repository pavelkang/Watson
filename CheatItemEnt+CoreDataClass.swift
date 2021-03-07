//
//  CheatItemEnt+CoreDataClass.swift
//  Watson
//
//  Created by Kai Kang on 2/22/21.
//
//

import Foundation
import CoreData
import Cocoa

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

    
    func set(key: String, with value: Any?) -> PayloadTrait {

        switch key {
        case "title":
            let title = value as! String
            if let ent = self.originalEnt {
                do {
                    let appDelegate = NSApplication.shared.delegate as! AppDelegate
                    let context = appDelegate.persistentContainer.viewContext
                    
                    ent.setValue(title, forKey: "title")
                    try context.save()
                } catch let error as NSError {
                    print(error)
                }
                print("changed title ent", ent)
                return CheatItem(fromEnt: ent as! CheatItemEnt)
            }
            return CheatItem(content: self.content, title: title)
        case "content":
            let content = value as! String
            if let ent = self.originalEnt {
                do {
                    let appDelegate = NSApplication.shared.delegate as! AppDelegate
                    let context = appDelegate.persistentContainer.viewContext
                    
                    ent.setValue(content, forKey: "content")
                    try context.save()
                } catch let error as NSError {
                    print(error)
                }
                return CheatItem(fromEnt: ent as! CheatItemEnt)
            }
            return CheatItem(content: content, title: self.title)
        default:
            print("ERROR", key, value)
            return self
        }
    }
    
    func getListViewAddTitle() -> String {
        return "Add " + self.content
    }
    
    func getListViewReadTitle() -> String {
        return self.title.count > 0 ? self.title : self.content
    }
    
    func contentEqual(other: PayloadTrait) -> Bool {
        let otherCheatItem = other as! CheatItem
        return self.title == otherCheatItem.title && self.content == otherCheatItem.content
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
    var originalEnt: NSManagedObject?
    
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
        self.originalEnt = ent
    }
}
