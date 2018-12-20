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

class MainViewController: UIViewController {
    
    @IBOutlet var progressView: UIProgressView?
    @IBOutlet var progressLabel: UILabel?
    @IBOutlet var ateButton: UIButton?
//    let realm: Realm = try! Realm()
    let realm: Realm = try! Realm(configuration: Realm.Configuration(schemaVersion: 1))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // レイアウトの初期設定
        initLayout()
        
        // DBの内容を初期化
        //MARK: テストのため，使用している。本番では使わない。
        deleteAll()
        
        // GIFアニメーション表示
        showGifAnimation(gifName: "hiyori_chan/a_idling(hiyori_m01)/idling.gif")
        
        // セリフ表示用吹き出し表示
        showBalloon(serif: "おはよー")
        
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
        progressView?.trackTintColor = .white
        progressView?.progressTintColor = UIColor(hex: "FF7043")
        progressView?.setProgress(0, animated: false)
        
        progressLabel?.text = "0 / 3"
        
        ateButton?.backgroundColor = UIColor(hex: "FF7043")
        ateButton?.layer.borderWidth = 1.0
        ateButton?.layer.borderColor = UIColor(hex: "FF7043").cgColor
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
        imageview.frame = CGRect(x: 200, y: 300, width: 500, height: 800)
        imageview.center = view.center
        view.addSubview(imageview)
        view.bringSubviewToFront(ateButton!)
    }
    
    /** 吹き出しを表示
     * @param selif 話させるセリフ
     * @return セリフ自体を表示しているUILabel
     */
    func showBalloon(serif: String) -> UILabel {
        let imageView = UIImageView(image: UIImage(named: "balloon_white_clear_orange.png"))
        imageView.frame = CGRect(x: (view.bounds.size.width) / 2, y: 400, width: 330, height: 150)
        imageView.center = view.center
        view.addSubview(imageView)
        
        let commentLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        commentLabel.text = serif
        commentLabel.textAlignment = .center
        imageView.addSubview(commentLabel)
        
        return commentLabel
    }
}
