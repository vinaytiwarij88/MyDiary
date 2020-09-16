//
//  BaseViewController.swift
//  MyDiary
//
//  Created by PCQ224 on 16/09/20.
//  Copyright © 2020 PCQ224. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class BaseViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    ///`Activity Indicator`
    func startLoading() {
        SVProgressHUD.show()
    }
    func stopLoading() {
        SVProgressHUD.dismiss()
    }
}

