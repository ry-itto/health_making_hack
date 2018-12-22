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
    
    static let breakFactStart: Date = setTodayTime(hour: 5, minute: 0, second: 0)!
    static let breakFactEnd: Date = setTodayTime(hour: 10, minute: 0, second: 0)!
    static let lunchStart: Date = setTodayTime(hour: 10, minute: 0, second: 0)!
    static let lunchEnd: Date = setTodayTime(hour: 16, minute: 0, second: 0)!
    static let dinnerStart: Date = setTodayTime(hour: 16, minute: 0, second: 0)!
    static let dinnerEnd: Date = setTodayTime(hour: 20, minute: 0, second: 0)!
    
    static let realm: Realm = try! Realm(configuration: Realm.Configuration(schemaVersion: 3))
    
    // 朝食の時間か判定します。
    static func isBreakFastTime() -> Bool {
        let now = Date()
        return now.timeIntervalSince(breakFactStart) > 0.0 && breakFactEnd.timeIntervalSince(now) > 0.0
    }
    
    // 昼食の時間か判定します。
    static func isLunchTime() -> Bool {
        let now = Date()
        return now.timeIntervalSince(lunchStart) > 0.0 && lunchEnd.timeIntervalSince(now) > 0.0
    }
    
    // 夕食の時間か判定します。
    static func isDinnertime() -> Bool {
        let now = Date()
        return now.timeIntervalSince(dinnerStart) > 0.0 && dinnerEnd.timeIntervalSince(now) > 0.0
    }
    
    // 夜食の時間か判定します。
    static func isSupperTime() -> Bool {
        return !(isBreakFastTime() || isLunchTime() || isDinnertime())
    }
    
    // 朝食を食べずに朝食時間を過ぎたかどうか判定します。
    static func didnotTakeBreakFast() -> Bool {
        let now = Date()
        let results: Results<EatRecord> = realm.objects(EatRecord.self)
            .filter("ateDate >= \(breakFactStart) AND ateDate <= \(breakFactEnd)")
        return now.timeIntervalSince(breakFactEnd) > 0.0 && results.isEmpty
    }
    
    // 昼食を食べずに昼食時間を過ぎたかどうか判定します。
    static func didnotTakeLunch() -> Bool {
        let now = Date()
        let results: Results<EatRecord> = realm.objects(EatRecord.self)
            .filter("ateDate >= \(lunchStart) AND ateDate <= \(lunchEnd)")
        return now.timeIntervalSince(lunchEnd) > 0.0 && results.isEmpty
    }
    
    // 夕食を食べずに夕食時間を過ぎたかどうか判定します。
    static func didnotTakeDinner() -> Bool {
        let now = Date()
        let results: Results<EatRecord> = realm.objects(EatRecord.self)
            .filter("ateDate >= \(dinnerStart) AND ateDate <= \(dinnerEnd)")
        return now.timeIntervalSince(dinnerEnd) > 0.0 && results.isEmpty
    }
    
    // 現在の時間帯に食事をしたかどうかを判定します。
    static func dontEatYet() -> Bool {
        if isBreakFastTime() {
            return realm.objects(EatRecord.self)
                .filter("ateDate >= %@ AND ateDate <= %@", breakFactStart, breakFactEnd).isEmpty
        } else if isLunchTime() {
            return realm.objects(EatRecord.self)
                .filter("ateDate >= %@ AND ateDate <= %@", lunchStart, lunchEnd).isEmpty
        } else if isDinnertime() {
            return realm.objects(EatRecord.self)
                .filter("ateDate >= %@ AND ateDate <= %@", dinnerStart, dinnerEnd).isEmpty
        } else if isSupperTime() {
            return true
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
