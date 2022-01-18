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

@objc(TodayItemEnt)
public class TodayItemEnt: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodayItemEnt> {
        return NSFetchRequest<TodayItemEnt>(entityName: "TodayItemEnt")
    }

    @NSManaged public var content: String

    var app: AppType = AppType.TodoAppType
    
}

struct TodayItem: PayloadTrait, Hashable, Identifiable {
    
    func set(key: String, with value: Any?) -> PayloadTrait {

        switch key {
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
            return CheatItem(content: content)
        default:
            print("ERROR", key, value)
            return self
        }
    }
    
    func getListViewAddTitle() -> String {
        return "Add " + self.content
    }
    
    func getListViewReadTitle() -> String {
        self.content
    }
    
    func contentEqual(other: PayloadTrait) -> Bool {
        if other.app != self.app {
            return false
        }
        let otherTodayItem = other as! TodayItem
        return self.content == otherTodayItem.content
    }
    
    func get(key: String) -> Any? {
        switch key {
        case "content":
            return self.content
        default:
            print("ERROR", key)
            return ""
        }
    }
    
    
    var app: AppType = AppType.TodoAppType
    
    var content: String
    var originalEnt: NSManagedObject?
    
    var id: String {
        content
    }
    
    init(content: String) {
        self.content = content
    }
    
    init(fromEnt ent: TodayItemEnt) {
        self.content = ent.content
        self.originalEnt = ent
    }
}
