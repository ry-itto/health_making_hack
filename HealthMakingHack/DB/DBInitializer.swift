//
//  DBInitializer.swift
//  HealthMakingHack
//
//  Created by 伊藤凌也 on 2018/12/21.
//  Copyright © 2018 uoa_RLS. All rights reserved.
//

import Foundation
import RealmSwift

class DBInitializer {
    static func setUp() {
        let realm = try! Realm(configuration: Realm.Configuration(schemaVersion: 2))
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        try! realm.write {
            realm.add(createSerifModels())
            realm.add(createMotionModels())
        }
    }
    
    static private func createSerifModels() -> Array<Serif> {
        var serifModels: Array<Serif> = []
        var id: Int = 1
        for hiyoriSerif in HiyoriSerif.serifs {
            for motionId in hiyoriSerif.motionIds {
                let serif = Serif()
                serif.id = id
                serif.text = hiyoriSerif.text
                serif.motionId = motionId
                serif.type = hiyoriSerif.serifType.rawValue
                serifModels.append(serif)
                id += 1
            }
        }
        return serifModels
    }
    
    static private func createMotionModels() -> Array<Motion> {
        var motionModels: Array<Motion> = []
        for hiyoriMotion in HiyoriMotion.motions {
            let motion = Motion()
            motion.id = hiyoriMotion.id
            motion.japaneseMotionName = hiyoriMotion.japaneseMotionName
            motion.motionName = hiyoriMotion.motionName
            motion.motionPath = hiyoriMotion.path
            motionModels.append(motion)
        }
        return motionModels
    }
}
