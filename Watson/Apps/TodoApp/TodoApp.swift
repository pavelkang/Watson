//
//  TodoApp.swift
//  Watson
//
//  Created by Kai Kang on 3/19/21.
//

import Foundation
import Cocoa

class TodoApp: WatsonApp {

    init() {
        super.init(name: "Todo")
    }
    
    func captureIntentToCreate(query: String) -> Suggestion {        
        let todo = TodayItem(content: query)
        
        let qas = [
            QuickAction.SaveItemAction(identifier: "", item: todo, action: {
                payload in
                guard let appDelegate =
                  NSApplication.shared.delegate as? AppDelegate else {
                  return
                }
                let managedContext =
                  appDelegate.persistentContainer.viewContext
                let entity =
                  NSEntityDescription.entity(forEntityName: "TodayItemEnt",
                                             in: managedContext)!
                let todayItemEnt = NSManagedObject(entity: entity, insertInto: managedContext) as! TodayItemEnt

                todayItemEnt.setValue(payload!.get(key: "content") as! String, forKey: "content")

                do {
                  try managedContext.save()
                } catch let error as NSError {
                  print("Could not save. \(error), \(error.userInfo)")
                }
            })
        ]
        
        
        return Suggestion.FromNew(payload: todo, qas: qas)
    }
    
    override func search(query: String) -> [Suggestion] {
        return [captureIntentToCreate(query: query)]
    }
    
    override var symbol: String {
        "pencil.tip.crop.circle"
    }

}
