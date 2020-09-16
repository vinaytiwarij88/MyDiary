//
//  DiaryDetailView.swift
//  MyDiary
//
//  Created by PCQ224 on 16/09/20.
//  Copyright © 2020 PCQ224. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DiaryDataView: UIView {
    
    //MARK: - Outlets
    @IBOutlet private weak var vwParent           : UIView!
    @IBOutlet private weak var lblTite       : UILabel!
    @IBOutlet private weak var lblDescription      : UILabel!
    @IBOutlet private weak var lblDateTime   : UILabel!
    @IBOutlet private weak var btnEdit       : UIButton!
    @IBOutlet private weak var btnDelete     : UIButton!
    
    //MARK: - Callbacks
    var btnEditClicked:((String) -> Void)?
    var btnDeleteClicked:((String) -> Void)?
    
    //MARK: - Variables
    var disposeBag = DisposeBag()
    
    //MARK: - Property Observers
    var diaryDetail : DiaryData! {
        didSet {
            prapareActionMethods()
            lblTite.text = diaryDetail.title
            lblDescription.text = diaryDetail.desc
            DispatchQueue.main.async {
                self.vwParent.dropShadow(color: .gray, opacity: 0.4, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
            }
        }
    }
    
    var diaryType : DiaryType! {
        didSet {
            if let date = diaryDetail.date {
                switch  diaryType {
                case .today, .yesterday:
                    lblDateTime.text = getHourDifference(from: date)
                case .old:
                    lblDateTime.text = getWeekDifference(from: date)
                case .none:
                    break
                }
            }
        }
    }
    
    //MARK: - Action Methods
    private func prapareActionMethods() {
        btnEdit.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = `self` else {
                return
            }
            self.btnEditClicked?(self.diaryDetail.id ?? "")
        }).disposed(by: disposeBag)
        
        btnDelete.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = `self` else {
                return
            }
            self.btnDeleteClicked?(self.diaryDetail.id ?? "")
        }).disposed(by: disposeBag)
    }
    
    //MARK: - Helper Methods
    private func getHourDifference(from date : Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: date, to: Date())
        let hours = components.hour ?? 0
        return " \(abs(hours)) hours ago"
    }
    
    private func getWeekDifference(from date : Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date, to: Date())
        let weeks = Int((components.day ?? 0) / 7)
        return " \(abs(weeks)) weeks ago"
    }
}
