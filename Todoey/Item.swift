//
//  Item.swift
//  Todoey
//
//  Created by Francisco Gonzalez on 29/07/2019.
//  Copyright © 2019 Francisco Gonzalez. All rights reserved.
//

import Foundation

class Item{
    
    var title : String = ""
    var done : Bool = false
    
    init(title: String) {
        self.title = title
        done = false
    }
}
