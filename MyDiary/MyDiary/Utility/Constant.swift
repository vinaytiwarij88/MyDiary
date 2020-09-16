//
//  Constant.swift
//  MyDiary
//
//  Created by PCQ224 on 16/09/20.
//  Copyright © 2020 PCQ224. All rights reserved.
//

import Foundation
import UIKit

struct AppConstant {
    
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    struct MyDiaryDataModel {
        static let ID = "id"
        static let DATE = "latestDate"
        static let DESC = "desc"
        static let TITLE = "title"
    }
}
