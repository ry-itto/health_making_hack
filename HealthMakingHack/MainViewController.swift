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
    let realm: Realm = try! Realm(configuration: Realm.Configuration(schemaVersion: 3))
    var commentLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // レイアウトの初期設定
        initLayout()
        
        // DBの内容を初期化。EatRecordのみを削除
         deleteAll()
        
        // GIFアニメーション表示
        showGifAnimation(gifName: "idling")
        
        // セリフ表示用吹き出し表示
        commentLabel = showBalloon(serif: "おはよおおおおおおおおおおおおおおおおおおおおおおおおおおおおおおおお")
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
//            realm.deleteAll()
            realm.delete(realm.objects(EatRecord.self))
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
        
        // GIF画像がタップされたことを検知するものを定義
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,                                                  action: #selector(hiyoriChanTapped(tapGestureRecognizer:)))
        
        // GIF画像を表示するための設定
        let gifImage = UIImage(gifName: gifName)
        let imageview = UIImageView(gifImage: gifImage, loopCount: -1) // Use -1 for infinite loop
        imageview.frame = CGRect(x: 200, y: 300, width: 500, height: 800)
        imageview.center = view.center
        imageview.isUserInteractionEnabled = true
        imageview.addGestureRecognizer(tapGestureRecognizer)
        
        // メインビューに表示
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
        
        let commentLabel = UILabel(frame: CGRect(x: 50, y: 50, width: 200, height: 100))
        commentLabel.text = serif
        commentLabel.textAlignment = .center
        commentLabel.numberOfLines = 0
        commentLabel.sizeToFit()
        imageView.addSubview(commentLabel)
        
        return commentLabel
    }
    
    /**
     * GIF画像がタップされた時の動作
     * Motionテーブルからtypeが1のデータを全て取得し，その中のランダムな要素を使用する
     * GIF画像，吹き出し内メッセージを変更する。
     */
    @objc func hiyoriChanTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        let serifs: Results<Serif> = realm.objects(Serif.self).filter("type == 1")
        let serif: Serif? = serifs.randomElement()
        
        tappedImage.gifImage = UIImage(gifName: serif?.motion?.motionPath ?? "")
        commentLabel?.text = serif?.text
    }
}
