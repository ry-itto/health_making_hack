//
//  Serif.swift
//  HealthMakingHack
//
//  Created by 伊藤凌也 on 2018/12/20.
//  Copyright © 2018 uoa_RLS. All rights reserved.
//

import Foundation
import RealmSwift

class Serif: Object {
    @objc dynamic var id = 0
    @objc dynamic var type = SerifType.tapMotion.rawValue
    @objc dynamic var text = ""
    @objc dynamic var motionId = 1
    
    enum SerifType: Int {
        case tapMotion = 1
        case hunger = 2
        case full = 3
        case nightHunger = 4
        case less = 5
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
