//
//  CheatSheetApp.swift
//  Watson
//
//  Created by Kai Kang on 1/24/21.
//

import Foundation
import Cocoa

class CheatsheetApp: WatsonApp {
    var databaseForTest: Set<CheatItem> = Set<CheatItem>()
    
    init() {
        super.init(name: "Cheatsheet")
    }
    
    func _loadAllCheatItems() -> Void {
        
    }
    
    func captureIntentToCreate(query: String) -> Suggestion {
        let item = CheatItem(content: query)
        let qas = [
            QuickAction.CreateItemAction(
                identifier: "", item: item,
                action: { payload in
                    // Need to get the payload
                    guard let appDelegate =
                      NSApplication.shared.delegate as? AppDelegate else {
                      return
                    }
                    let managedContext =
                      appDelegate.persistentContainer.viewContext
                    let entity =
                      NSEntityDescription.entity(forEntityName: "CheatItemEnt",
                                                 in: managedContext)!
                    let cheatItemEnt = NSManagedObject(entity: entity, insertInto: managedContext) as! CheatItemEnt

                    cheatItemEnt.setValue(payload!.get(key: "content") as! String, forKey: "content")
                    cheatItemEnt.setValue(payload!.get(key: "title") as! String, forKey: "title")
                    

                    do {
                      try managedContext.save()
                    } catch let error as NSError {
                      print("Could not save. \(error), \(error.userInfo)")
                    }
                })
        ]
        return Suggestion.FromNew(
            payload: item, qas: qas
        )
    }
    
    override func search(query: String) -> [Suggestion] {
        print("SEARCH", query)
        guard let appDelegate =
          NSApplication.shared.delegate as? AppDelegate else {
          return []
        }
        let moc = appDelegate.persistentContainer.viewContext
        
        // Create Fetch Request
        /*
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CheatItemEnt")

        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try moc.execute(batchDeleteRequest)

        } catch {
            // Error Handling
        }*/
        
        
        let cheatItemEntFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CheatItemEnt")
        var fetchedCheatItemEnts: [CheatItemEnt] = []
        do {
            fetchedCheatItemEnts = try moc.fetch(cheatItemEntFetch) as! [CheatItemEnt]
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        print("Fetched items", fetchedCheatItemEnts)
        
        let createIntents: Suggestion =  captureIntentToCreate(query: query)
//        let results: Set<CheatItem> = databaseForTest.filter {
//            let corpus: String = ($0.title ?? "") + $0.content
//            return corpus.lowercased().contains(query.lowercased())
//        }
        var readIntents: [Suggestion] = fetchedCheatItemEnts.map { cheatItemEnt -> Suggestion in
            
            let cheatItem = CheatItem(fromEnt: cheatItemEnt)
            
            var qas: [QuickAction] = []
            if let _ = NSURL(string: cheatItemEnt.content) {
                qas.append(QuickAction.OpenInBrowserAction(identifier: cheatItem.id, url: cheatItem.content))
            }
            qas.append(QuickAction.CopyToClipBoardAction(identifier: cheatItem.id, content: cheatItem.content))
            return Suggestion.FromExisting(
                payload: cheatItem,
                qas: qas
            )
        }
        readIntents.append(createIntents)
        return readIntents
    }
    
    override var symbol: String {
        "books.vertical"
    }
}
