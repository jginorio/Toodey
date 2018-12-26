//
//  Category.swift
//  Todoey
//
//  Created by Jaime Sebastian Ginorio Ramirez on 12/24/18.
//  Copyright © 2018 Jaime Sebastian Ginorio Ramirez. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    
    //Properties
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    
    //Inverse relationship with the item 
    let items = List<Item>()
    
    
    
}
