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
        static let TITLE_REQUIRED = appName
        static let SAVE_DETAILS = "Please enter required detail to save the journal."
    }
}
