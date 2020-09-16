//
//  DiaryWrappers.swift
//  MyDiary
//
//  Created by PCQ224 on 16/09/20.
//  Copyright © 2020 PCQ224. All rights reserved.
//

import Foundation

enum DiaryType {
    case today
    case yesterday
    case old(_ month: String)
    
    var title: String {
        switch self {
        case .today:
            return "Today"
        case .yesterday:
            return "Yesterday"
        case .old(let month):
            return month
        }
    }
}

struct DiaryGroup {
    var type : DiaryType
    var diaryList = [DiaryData]()
}
