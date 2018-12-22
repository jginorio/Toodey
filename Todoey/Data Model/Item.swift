//
//  Item.swift
//  Todoey
//
//  Created by Jaime Sebastian Ginorio Ramirez on 12/21/18.
//  Copyright © 2018 Jaime Sebastian Ginorio Ramirez. All rights reserved.
//

import Foundation

class Item: Codable {
    //Properties
    var task : String = ""
    var done : Bool = false
    
    init(task: String) {
        self.task = task
    }
    
}
