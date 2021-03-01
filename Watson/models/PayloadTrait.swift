//
//  PayloadTrait.swift
//  Watson
//
//  Created by Kai Kang on 2/25/21.
//

import Foundation

protocol PayloadTrait {
    var app: AppType { get }

    mutating func set(key: String, with value: Any?)
    
    func get(key: String) -> Any?
}
