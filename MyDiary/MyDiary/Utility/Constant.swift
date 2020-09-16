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
    static let appName = "MyDiary"
    
    struct Alert {
        static let NO =   "No".localized
        static let YES = "Yes".localized
        static let TITLE_REQUIRED = appName
        static let TITLE_CONFIRMATION = appName
        static let SAVE_DETAILS = "Please enter required detail to save the journal.".localized
        static let REMOVE_ITEM = "Are you sure that you want to remove this item?".localized
    }
}
