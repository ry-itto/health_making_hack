//
//  Motion.swift
//  HealthMakingHack
//
//  Created by 伊藤凌也 on 2018/12/21.
//  Copyright © 2018 uoa_RLS. All rights reserved.
//

import Foundation
import RealmSwift

class Motion: Object {
    @objc dynamic var id = 0
    @objc dynamic var japaneseMotionName = ""
    @objc dynamic var motionName = ""
    @objc dynamic var motionPath = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
