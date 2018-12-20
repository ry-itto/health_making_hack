//
//  Seed.swift
//  HealthMakingHack
//
//  Created by 伊藤凌也 on 2018/12/21.
//  Copyright © 2018 uoa_RLS. All rights reserved.
//

import Foundation

struct HiyoriMotion {
    static let motions: [(id: Int, japaneseMotionName: String, motionName: String, path: String)] = [
        (1, "普通", "normal", "idling"),
        (2, "普通(微笑む)","normal_with_smile", "idling_smile"),
        (3, "考える", "thinking", "thinking"),
        (4, "心配する" , "worry", "worried"),
        (5, "笑って驚く", "suprised_with_smile", "smile_to_suprised"),
        (6, "気分がいい", "happy", "feeling_good"),
        (7, "驚く", "suprised", "suprised"),
        (8, "怒る", "angry", "angry"),
        (9, "落ち込む", "upset", "sad"),
        (10, "笑う, 微笑む", "smile", "smiling")
    ]
}

struct HiyoriSerif {
    static let serifs: [(serifType: Serif.SerifType, text: String, motionIds: Array<Int>)] = [
        (Serif.SerifType.tapMotion, "22時から2時の間に食べると太りやすくなるらしいです!", [1, 3, 10]),
        (Serif.SerifType.tapMotion, "食事時間隔は4~5時間あけると胃に優しいそうです~", [1, 3, 10]),
        (Serif.SerifType.tapMotion, "さかな さかな さかな~♪ さかなを~たべ~ると~♫", [1, 3, 10]),
        (Serif.SerifType.tapMotion, "食事するときにボタンを押してくださいね~", [1, 3, 10]),
        (Serif.SerifType.tapMotion, "最初に言っておきますがズルはダメですよ", [1, 3, 10]),
        (Serif.SerifType.tapMotion, "寝る前の3時間以内は食べたり飲んだりするのはお勧めしません", [1, 3, 10]),
        (Serif.SerifType.tapMotion, "食事前に小腹が空いたらフルーツやヨーグルトなどおすすめです。", [1, 3, 10]),
        (Serif.SerifType.hunger, "腹ペコで力がでないです...", [9]),
        (Serif.SerifType.hunger, "なんだか気分が優れません...", [9]),
        (Serif.SerifType.hunger, "食べないのですか...?", [9]),
        (Serif.SerifType.hunger, "まだ...ですか??", [9]),
        (Serif.SerifType.full, "よく噛んで食べましたか...?", [5, 6, 7]),
        (Serif.SerifType.full, "次のお食事は4、5時間後を目安にすると胃に優しいですよ~。", [5, 6, 7]),
        (Serif.SerifType.full, "フゥ...私もお腹いっぱいです!", [5, 6, 7]),
        (Serif.SerifType.nightHunger, "太るよ!", [3, 8]),
        (Serif.SerifType.nightHunger, "この時間帯は体が脂肪を蓄えやすいんです!", [3, 8]),
        (Serif.SerifType.nightHunger, "もう!", [3, 8]),
        (Serif.SerifType.nightHunger, "このブタ野郎!", [3, 8]),
        (Serif.SerifType.less, "食べてくれないと心配です...", [4]),
        (Serif.SerifType.less, "明日はちゃんと3食きっちり食べてくださいね", [4]),
        (Serif.SerifType.less, "力が...出ない...です...", [4])
    ]
}
