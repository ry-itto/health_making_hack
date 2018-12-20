//
//  HealthKit.swift
//  HealthMakingHack
//
//  Created by 伊藤凌也 on 2018/12/18.
//  Copyright © 2018 uoa_RLS. All rights reserved.
//

import Foundation
import HealthKit

class HealthKit {
    
    let healthStore = HKHealthStore()
    
    // 認証処理をする
    private func authentication(healthStore: HKHealthStore,
                                writeType: Set<HKQuantityType>?,
                                readType: Set<HKQuantityType>?) {
        healthStore.requestAuthorization(toShare: nil, read: readType, completion: { (success, error) in
            if success {
                print("Health Auth Success")
            } else {
                print("Health Auth Failed")
            }
        })
    }
    
    /** ヘルスケアのストアからWorkoutのデータを取得する。
     * @param healthStore ヘルスケアキット
     * @param startDate データ取得開始日付
     * @param endDate データ取得終了日付
     * @return Workoutの配列
     */
    private func getWorkOut(healthStore: HKHealthStore, startDate: Date, endDate: Date) -> Array<HKWorkout> {
//        // 取得する期間を設定
//        let dateformatter = DateFormatter()
//        dateformatter.dateFormat = "yyyy/MM/dd"
//        let startDate = dateformatter.date(from: "2017/12/01")
//        let endDate = dateformatter.date(from: "2018/01/01")
        var returnArray: Array<HKWorkout>?
        
        // 取得するデータを設定
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        let sort = [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)]
        let q = HKSampleQuery(sampleType: HKObjectType.workoutType(), predicate: predicate, limit: 0, sortDescriptors: sort, resultsHandler:{
            (query, result, error) in
            
            if let e = error {
                print("Error: \(e.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                guard let r = result else { return }
                
                returnArray = r as? [HKWorkout]
            }
        })
        
        healthStore.execute(q)
        guard let r = returnArray else { return [] }
        
        return r
    }
    
    private func getSteps(startDate: Date, endDate: Date) {
        let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        let quantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
    }
}
