//
//  EatTime.swift
//  HealthMakingHack
//
//  Created by 伊藤凌也 on 2018/12/21.
//  Copyright © 2018 uoa_RLS. All rights reserved.
//

import Foundation
import RealmSwift

struct EatTime {
    
    static let fiveOclock: Date = setTodayTime(hour: 5, minute: 0, second: 0)!
    static let tenOclock: Date = setTodayTime(hour: 10, minute: 0, second: 0)!
    static let elevenOclock: Date = setTodayTime(hour: 11, minute: 0, second: 0)!
    static let fourteenOclock: Date = setTodayTime(hour: 14, minute: 0, second: 0)!
    static let sixteenOclock: Date = setTodayTime(hour: 16, minute: 0, second: 0)!
    static let twentyOclock: Date = setTodayTime(hour: 20, minute: 0, second: 0)!
    
    static let realm: Realm = try! Realm(configuration: Realm.Configuration(schemaVersion: 3))
    
    // 朝食の時間か判定します。
    static func isBreakFastTime() -> Bool {
        let now = Date()
        return now.timeIntervalSince(fiveOclock) > 0.0 && tenOclock.timeIntervalSince(now) > 0.0
    }
    
    // 昼食の時間か判定します。
    static func isLunchTime() -> Bool {
        let now = Date()
        return now.timeIntervalSince(elevenOclock) > 0.0 && fourteenOclock.timeIntervalSince(now) > 0.0
    }
    
    // 夕食の時間か判定します。
    static func isDinnertime() -> Bool {
        let now = Date()
        return now.timeIntervalSince(sixteenOclock) > 0.0 && twentyOclock.timeIntervalSince(now) > 0.0
    }
    
    // 夜食の時間か判定します。
    static func isSupperTime() -> Bool {
        return !(isBreakFastTime() || isLunchTime() || isDinnertime())
    }
    
    // 朝食を食べずに朝食時間を過ぎたかどうか判定します。
    static func didnotTakeBreakFast() -> Bool {
        let now = Date()
        let results: Results<EatRecord> = realm.objects(EatRecord.self)
            .filter("ateDate >= \(fiveOclock) AND ateDate <= \(tenOclock)")
        return now.timeIntervalSince(tenOclock) > 0.0 && results.isEmpty
    }
    
    // 昼食を食べずに昼食時間を過ぎたかどうか判定します。
    static func didnotTakeLunch() -> Bool {
        let now = Date()
        let results: Results<EatRecord> = realm.objects(EatRecord.self)
            .filter("ateDate >= \(elevenOclock) AND ateDate <= \(fourteenOclock)")
        return now.timeIntervalSince(fourteenOclock) > 0.0 && results.isEmpty
    }
    
    // 夕食を食べずに夕食時間を過ぎたかどうか判定します。
    static func didnotTakeDinner() -> Bool {
        let now = Date()
        let results: Results<EatRecord> = realm.objects(EatRecord.self)
            .filter("ateDate >= \(sixteenOclock) AND ateDate <= \(twentyOclock)")
        return now.timeIntervalSince(twentyOclock) > 0.0 && results.isEmpty
    }
    
    // 現在の時間帯に食事をしたかどうかを判定します。
    static func dontEatYet() -> Bool {
        if isBreakFastTime() {
            return realm.objects(EatRecord.self)
                .filter("ateDate >= %@ AND ateDate <= %@", fiveOclock, tenOclock).isEmpty
        } else if isLunchTime() {
            return realm.objects(EatRecord.self)
                .filter("ateDate >= %@ AND ateDate <= %@", elevenOclock, fourteenOclock).isEmpty
        } else if isDinnertime() {
            return realm.objects(EatRecord.self)
                .filter("ateDate >= %@ AND ateDate <= %@", sixteenOclock, twentyOclock).isEmpty
        }
        return false
    }
    
    // 日付はその日のままで，H, M, Sのみを指定して新しくDateオブジェクトを作成し，返却します。返り値はOptional
    private static func setTodayTime(hour: Int, minute: Int, second: Int) -> Date? {
        let calendar: Calendar = Calendar.current
        let now: Date = Date()
        return calendar.date(from: DateComponents(year: calendar.component(.year, from: now),
                                                  month: calendar.component(.month, from: now),
                                                  day: calendar.component(.day, from: now),
                                                  hour: hour,
                                                  minute: minute,
                                                  second: second))
    }
}
