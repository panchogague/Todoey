//
//  Category.swift
//  Todoey
//
//  Created by Francisco Gonzalez on 12/08/2019.
//  Copyright © 2019 Francisco Gonzalez. All rights reserved.
//

import Foundation
import RealmSwift

class Category :Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
