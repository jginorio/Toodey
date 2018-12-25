//
//  Item.swift
//  Todoey
//
//  Created by Jaime Sebastian Ginorio Ramirez on 12/24/18.
//  Copyright © 2018 Jaime Sebastian Ginorio Ramirez. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    //Properties
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var date: Date?
    
    
    /*Inverse relationship with the category, property means the items array
     *Here we specify the inverse relationship that link each item back with a
     *parent category
     */
 
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
