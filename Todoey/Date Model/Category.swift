//
//  Category.swift
//  Todoey
//
//  Created by YU on 2018/12/11.
//  Copyright © 2018 ameyo. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var colour: String = ""
    let items = List<Item>()
    //let array = Array<Int>()
}
