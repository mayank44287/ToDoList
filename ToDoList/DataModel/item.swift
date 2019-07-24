//
//  item.swift
//  ToDoList
//
//  Created by Mayank Raj on 7/20/19.
//  Copyright © 2019 Mayank Raj. All rights reserved.
//

import Foundation

class Item : Codable{       // u can use encodable and decodable together or use codable for both
    
    var title : String = ""
    var done : Bool = false
}
