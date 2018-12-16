//
//  MainViewController.swift
//  HealthMakingHack
//
//  Created by 伊藤凌也 on 2018/12/16.
//  Copyright © 2018 uoa_RLS. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
    
    @IBOutlet var progressView: UIProgressView?
    @IBOutlet var progressLabel: UILabel?
    @IBOutlet var ateButton: UIButton?
    let realm: Realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView?.trackTintColor = UIColor.red
        progressView?.progressTintColor = .blue
        progressView?.setProgress(0.3, animated: false)
        
        progressLabel?.text = "1 / 3"
        
        ateButton?.backgroundColor = .blue
        ateButton?.layer.borderWidth = 1.0
        ateButton?.layer.borderColor = UIColor.black.cgColor
        ateButton?.layer.cornerRadius = 10.0
        ateButton?.setTitleColor(.white, for: .normal)
    }
    
    @IBAction func ateButtonTapped(_ sender: UIButton) {
        let record: EatRecord = EatRecord()
        record.ateDate = Date()
        try! realm.write {
            realm.add(record)
        }
        showEatRecords()
    }
    
    func showEatRecords() {
        let results = realm.objects(EatRecord.self)
        for item in results {
            print("date:\(item.ateDate)")
        }
    }
}
