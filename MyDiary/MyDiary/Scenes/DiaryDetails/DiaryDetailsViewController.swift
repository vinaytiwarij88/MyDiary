//
//  DiaryDetailsViewController.swift
//  MyDiary
//
//  Created by PCQ224 on 16/09/20.
//  Copyright © 2020 PCQ224. All rights reserved.
//
import UIKit

class DiaryDetailViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet private weak var txtFTitle   : UITextField!
    @IBOutlet private weak var txtVContent  : UITextView!
    @IBOutlet private weak var btnSave       : UIButton!
    
    //MARK: - Variables
    private var viewModel = DiaryDetailViewModel()
    var diaryItem: DiaryData?
    
    //MARK: - Callback
    var shouldRefresh:((Bool) -> Void)?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        saveDiaryData()
    }
    
    //MARK: - Helper Methods
    private func setData() {
        
        if let diaryObj = diaryItem {
            txtFTitle.text = diaryObj.title
            txtVContent.text = diaryObj.content
        }
        
        txtFTitle.rx.text.orEmpty.bind(to: viewModel.title).disposed(by: disposeBag)
        txtVContent.rx.text.orEmpty.bind(to: viewModel.detail).disposed(by: disposeBag)
        prepareTextFieldDelegate()
        
    }
}

//MARK: - Action Methods
extension DiaryDetailViewController {
    
    private func saveDiaryData() {
        
        btnSave.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = `self` else {
                return
            }
            
            if let id  = self.diaryItem?.id {
                if self.txtFTitle.text?.trimmed.isEmpty ?? true || self.txtVContent.text.trimmed.isEmpty {
                    self.showAlert(title: AppConstant.Alert.TITLE_REQUIRED, message: AppConstant.Alert.SAVE_DETAILS)
                    return
                }
                
                self.viewModel.saveData(for: id)
                self.shouldRefresh?(true)
                self.navigationController?.popViewController(animated: true)
            }
            
        }).disposed(by: disposeBag)
        
    }
}

//MARK: - TextField Delegate
extension DiaryDetailViewController {
    
    private func prepareTextFieldDelegate() {
        
        txtFTitle.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { [weak self] in
            guard let self = `self` else {
                return
            }
            self.txtVContent.resignFirstResponder()
        }).disposed(by: self.disposeBag)
        
    }
}
