//
//  DiaryDetailsViewModel.swift
//  MyDiary
//
//  Created by PCQ224 on 16/09/20.
//  Copyright © 2020 PCQ224. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class DiaryDetailViewModel: BaseViewModel {
    
    //MARK: - Variables
    var title   = BehaviorRelay<String>(value: "")
    var detail  = BehaviorRelay<String>(value: "")
    
    func saveData(for id: String) {
        if !title.value.isEmpty && !detail.value.isEmpty {
            DatabaseManager.shared.updateData(for: id, title: title.value, content: detail.value)
        }
    }
}


