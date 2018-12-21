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

    let tenMinites: Double = 600000
    
    @IBOutlet var progressView: UIProgressView?
    @IBOutlet var progressLabel: UILabel?
    @IBOutlet var ateButton: UIButton?
    let realm: Realm = try! Realm(configuration: Realm.Configuration(schemaVersion: 3))
    var gifView: UIImageView?
    var commentLabel: UILabel?
    
    // 時刻を表示するラベル
    @IBOutlet var labelClock: UILabel!//remove bar
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // レイアウトの初期設定
        initLayout()
        
        // DBの内容を初期化。EatRecordのみを削除
//        deleteAll()
        
        // GIFアニメーション表示
        showGifAnimation(gifName: "idling")
        
        // セリフ表示用吹き出し表示
        commentLabel = showBalloon(serif: "食事前に小腹が空いたらフルーツやヨーグルトなどおすすめです。          ")
        
        Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true, block: { (time) in
            if self.getLatestEatRecord()?.ateDate.timeIntervalSinceNow
                .isLessThanOrEqualTo(self.tenMinites) ?? false {
                self.ateButtonTapped()
                print("condition: full")
            } else if Date().timeIntervalSince(EatTime.tenOclock).isLessThanOrEqualTo(self.tenMinites) ||
                Date().timeIntervalSince(EatTime.fourteenOclock).isLessThanOrEqualTo(self.tenMinites) ||
                Date().timeIntervalSince(EatTime.twentyOclock).isLessThanOrEqualTo(self.tenMinites) {
                self.untilTimeOver()
                print("condition: hunger")
            } else if EatTime.didnotTakeBreakFast() ||
                EatTime.didnotTakeLunch() ||
                EatTime.didnotTakeDinner() {
                self.didnotEat()
                print("condition: less")
            }
        })
        // 1秒ごとに「displayClock」を実行する
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(displayClock), userInfo: nil, repeats: true)
        timer.fire()    // 無くても動くけどこれが無いと初回の実行がラグる
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 現在時刻を表示する処理
    @objc func displayClock() {
        // 現在時刻を「HH:MM:SS」形式で取得する
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        var displayTime = formatter.string(from: Date())    // Date()だけで現在時刻を表す
        
        // 0から始まる時刻の場合は「 H:MM:SS」形式にする
        if displayTime.hasPrefix("0") {
            // 最初に見つかった0だけ削除(スペース埋め)される
            if let range = displayTime.range(of: "0") {
                displayTime.replaceSubrange(range, with: " ")
            }
        }
        // ラベルに表示
        labelClock.text = displayTime
        labelClock.adjustsFontSizeToFitWidth = true//font のサイズ
        self.view.bringSubviewToFront(labelClock)
    }
    
    // 「食べた！」ボタンがタップされたときの動作
    @IBAction func ateButtonTapped(_ sender: UIButton) {
        guard EatTime.dontEatYet() else { return }
        
        let record: EatRecord = EatRecord()
        record.ateDateString = todayToString()
        
        try! realm.write {
            realm.add(record)
        }
        
        // progressViewの進行度を変更
        let eatRecordCountToday = countEatRecordsFromDay(dayString: todayToString())
        progressLabel?.text = "\(eatRecordCountToday) / 3"
        progressView?.setProgress(Float(0.334 * Double(eatRecordCountToday)), animated: true)
        
        // 食べた時間が時間時間外かどうか判定
        if EatTime.isSupperTime() {
            overEatTime()
            print("condition: nightEating")
        } else {
            ateButtonTapped()
            print("condition: full")
        }
    }

    
    // 画面レイアウトの初期化
    func initLayout() {
        guard let pv = progressView, let ab = ateButton else { return }
        
        pv.trackTintColor = .white
        pv.progressTintColor = UIColor(hex: "FF7043")
        pv.setProgress(0, animated: false)
        
        progressLabel?.text = "0 / 3"
        
        ab.backgroundColor = UIColor(hex: "FF7043")
        ab.layer.borderWidth = 1.0
        ab.layer.borderColor = UIColor(hex: "FF7043").cgColor
        ab.layer.cornerRadius = 10.0
        ab.setTitleColor(.white, for: .normal)
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
//            realm.delete(realm.objects(EatRecord.self))
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
        gifView = UIImageView(gifImage: gifImage, loopCount: -1) // Use -1 for infinite loop
        guard let gv = gifView else { return }
        gv.frame = CGRect(x: 200, y: 300, width: 500, height: 800)
        gv.center = view.center
        gv.isUserInteractionEnabled = true
        gv.addGestureRecognizer(tapGestureRecognizer)
        
        // メインビューに表示
        view.addSubview(gv)
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
     */
    @objc func hiyoriChanTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        gifImageChangeAndLabelChange(type: Serif.SerifType.tapMotion.rawValue)
    }
    
    /**
     * GIF画像，吹き出し内メッセージを変更するメソッド
     * typeからランダムに変更する
     */
    private func gifImageChangeAndLabelChange(type: Int) {
        let serifs: Results<Serif> = realm.objects(Serif.self).filter("type == \(type)")
        let serif: Serif? = serifs.randomElement()
        
        gifView?.gifImage = UIImage(gifName: serif?.motion?.motionPath ?? "")
        commentLabel?.text = serif?.text
    }
    
    // 「食べる！」ボタンがタップされた時の処理
    func ateButtonTapped() {
        gifImageChangeAndLabelChange(type: Serif.SerifType.full.rawValue)
    }
    
    // 推奨時間の10分前からちょうどその時間になるまでの処理
    func untilTimeOver() {
        gifImageChangeAndLabelChange(type: Serif.SerifType.hunger.rawValue)
    }
    
    // 夜間に食事した場合の処理
    func overEatTime() {
        gifImageChangeAndLabelChange(type: Serif.SerifType.nightHunger.rawValue)
    }
    
    // 食事時間帯に食べなかった時の処理
    func didnotEat() {
        gifImageChangeAndLabelChange(type: Serif.SerifType.less.rawValue)
    }
    
    // EatRecordの日時が最後のものを取得します。
    func getLatestEatRecord() -> EatRecord? {
        return realm.objects(EatRecord.self).sorted(byKeyPath: "ateDate", ascending: false).first
    }
}
