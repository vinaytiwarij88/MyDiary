//
//  DiaryListTblVwCell.swift
//  MyDiary
//
//  Created by PCQ224 on 16/09/20.
//  Copyright © 2020 PCQ224. All rights reserved.
//

import UIKit

final class DiaryListTblVwCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var stvDiaries: UIStackView!
    
    //MARK: - Callbacks
    var btnEditClicked:((String) -> Void)?
    var btnDeleteClicked:((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Property Observer
    var diaryDataObj: DiaryGroup! {
        didSet {
            lblTitle.text = diaryDataObj.type.title
            stvDiaries.removeArrangedSubviews()
            for diary in diaryDataObj.diaryList {
                setDiaryData(with: diary)
            }
        }
    }
    
    private func setDiaryData(with data: DiaryData) {
        let diaryView = DiaryDetailsView().getViewOfType(type: DiaryDetailsView.self)
        diaryView.diaryDetail   = data
        diaryView.diaryType     = diaryDataObj.type
        diaryView.editTap       = { id in
            self.btnEditClicked?(id)
        }
        diaryView.deleteTap     = { id in
            self.btnDeleteClicked?(id)
        }
        stvDiaries.addArrangedSubview(diaryView)
    }
   
}
