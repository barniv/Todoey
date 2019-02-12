//
//  Item.swift
//  tableView
//
//  Created by macbook on 6 Adar I 5779.
//  Copyright © 5779 macbook. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
