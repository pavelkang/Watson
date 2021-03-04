//
//  PayloadTrait.swift
//  Watson
//
//  Created by Kai Kang on 2/25/21.
//

import Foundation
import CoreData

protocol PayloadTrait {
    var app: AppType { get }
    
    var originalEnt: NSManagedObject? {get}
    
    func getListViewReadTitle() -> String
    func getListViewAddTitle() -> String

    func set(key: String, with value: Any?) -> PayloadTrait
    
    func get(key: String) -> Any?
    
    func contentEqual(other: PayloadTrait) -> Bool
}
