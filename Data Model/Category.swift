//
//  Category.swift
//  tableView
//
//  Created by macbook on 6 Adar I 5779.
//  Copyright © 5779 macbook. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    let items : List<Item> = List<Item>()
}
