//
//  BaseViewModel.swift
//  MyDiary
//
//  Created by PCQ224 on 16/09/20.
//  Copyright © 2020 PCQ224. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ViewModelState<T> {
    case loading
    case failure(WebError)
    case success(T)
    case finish(Bool)
}

class BaseViewModel {
    // Dispose Bag
    let disposeBag  = DisposeBag()
    let alertDialog = PublishSubject<(String)>()
    let toastDialog = PublishSubject<(String)>()
}
