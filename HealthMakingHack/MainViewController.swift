//
//  MainViewController.swift
//  HealthMakingHack
//
//  Created by 伊藤凌也 on 2018/12/16.
//  Copyright © 2018 uoa_RLS. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyGif
import HealthKit

class MainViewController: UIViewController {
    
    @IBOutlet var progressView: UIProgressView?
    @IBOutlet var progressLabel: UILabel?
    @IBOutlet var ateButton: UIButton?
//    let realm: Realm = try! Realm()
    let realm: Realm = try! Realm(configuration: Realm.Configuration(schemaVersion: 1))
    let healthStore = HKHealthStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // レイアウトの初期設定
        initLayout()
        
        // DBの内容を初期化
        deleteAll()
        
        // GIFアニメーション表示
        showGifAnimation(gifName: "hiyori_chan/a_idling(hiyori_m01)/idling.gif")
        
        // ヘルスケア系処理
        // 読みたいデータを指定
        let readType = Set([
            // 運動情報
            HKWorkoutType.workoutType()
        ])
    }
    
    // 「食べた！」ボタンがタップされたときの動作
    @IBAction func ateButtonTapped(_ sender: UIButton) {
        let record: EatRecord = EatRecord()
        record.ateDateString = todayToString()
        
        try! realm.write {
            realm.add(record)
        }
        
        // progressViewの進行度を変更
        let eatRecordCountToday = countEatRecordsFromDay(dayString: todayToString())
        progressLabel?.text = "\(eatRecordCountToday) / 3"
        progressView?.setProgress(Float(0.334 * Double(eatRecordCountToday)), animated: true)
        
    }
    
    // 画面レイアウトの初期化
    func initLayout() {
        progressView?.trackTintColor = UIColor.red
        progressView?.progressTintColor = .blue
        progressView?.setProgress(0, animated: false)
        
        progressLabel?.text = "0 / 3"
        
        ateButton?.backgroundColor = .blue
        ateButton?.layer.borderWidth = 1.0
        ateButton?.layer.borderColor = UIColor.black.cgColor
        ateButton?.layer.cornerRadius = 10.0
        ateButton?.setTitleColor(.white, for: .normal)
    }
    
    /**
     * @param dayString 日付をString型に変換したもの
     * @return その日の食べた回数
    */
    func countEatRecordsFromDay(dayString: String) -> Int {
        let results = realm.objects(EatRecord.self).filter("ateDateString == %@", dayString)
        return results.count
    }
    
    // 全レコードをコンソールに出力
    func showEatRecords() {
        let results = realm.objects(EatRecord.self)
        for item in results {
            print("date:\(item.ateDate), string: \(item.ateDateString)")
        }
    }
   
    // 全レコードを削除
    func deleteAll() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    // メソッド使用時の日付をString型へ変換する
    func todayToString() -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy/MM/dd"
        dateFormater.locale = Locale(identifier: "ja_JP")
        return dateFormater.string(from: Date())
    }
    
    /** GIFアニメーションを表示
     * デフォルトでは無限ループで出力するようにしています。
     * @param gifName gifファイルへのパス
     */
    func showGifAnimation(gifName: String) {
        let gif = UIImage(gifName: gifName)
        let imageview = UIImageView(gifImage: gif, loopCount: -1) // Use -1 for infinite loop
        imageview.frame = CGRect(x: 200, y: 300, width: 300, height: 500)
        imageview.center = view.center
        view.addSubview(imageview)
    }
}
