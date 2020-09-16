//
//  DiaryListViewController.swift
//  MyDiary
//
//  Created by PCQ224 on 16/09/20.
//  Copyright © 2020 PCQ224. All rights reserved.
//


import UIKit

final class DiaryListViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet private weak var tblVwMyEntry   : UITableView!
    @IBOutlet private weak var vwNoData           : UIView!
    @IBOutlet private weak var btnLoadData      : UIButton!
    
    //MARK: - Variables
    private lazy var viewModel      = DiaryListViewModel(self)
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        handleTableData()
        prepareAPICall()
        //        viewModel.getDiaryList()
        
        viewModel.fetchDataFromDB()
    }
    
    //MARK: - Helper Methods
    func addNodataView() {
        tblVwMyEntry.tableHeaderView = vwNoData
        btnLoadData.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = `self` else {
                return
            }
            self.viewModel.fetchDataFromDB()
        }).disposed(by: disposeBag)
    }
    
    private func showAlertForRemoveConfirmation(strId: String) {
        let refreshAlert = UIAlertController(title: AppConstant.Alert.TITLE_CONFIRMATION, message: AppConstant.Alert.REMOVE_ITEM, preferredStyle: .alert)
        
        refreshAlert.addAction(UIAlertAction(title: AppConstant.Alert.YES, style: .default, handler: { (action: UIAlertAction!) in
            refreshAlert.dismiss(animated: true, completion: {
                self.viewModel.deleteDiary(for: strId)
            })
        }))
        refreshAlert.addAction(UIAlertAction(title: AppConstant.Alert.NO, style: .cancel, handler: { (action: UIAlertAction!) in
            refreshAlert.dismiss(animated: true, completion: nil)
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
}

//MARK: - API Call Handler
extension DiaryListViewController {
    private func prepareAPICall() {
        viewModel.state.subscribe(onNext: { [weak self] state in
            
            guard let `self` = self else {
                return
            }
            
            switch state {
            case .loading:
                self.startLoading()
                
            case .failure(let error):
                self.stopLoading()
                DispatchQueue.main.async {
                    switch error {
                    case .noInternet:
                        self.showAlert(title: "Network error", message: "Unable to contact the server")
                        
                    default:
                        self.showAlert(title: "Error occurred", message: "Failed to retrieve data from server")
                    }
                }
            case .success:
                DispatchQueue.main.async {
                    self.tblVwMyEntry.tableHeaderView = nil
                }
                self.stopLoading()
                
            case .finish:
                print("Finish")
            }
        }).disposed(by: disposeBag)
    }
}

//MARK: - TableView Delegate and DataSource
extension DiaryListViewController {
    private func handleTableData() {
        viewModel.formatedDiaryList.bind(to: tblVwMyEntry.rx.items){ (tableView, row, item) -> UITableViewCell in
            let cell = tableView.registerAndGet(cell: DiaryListTblVwCell.self)!
            cell.diaryDataObj = item
            cell.btnEditClicked = { id in
                if let obj = self.viewModel.diaryList.first(where: {$0.id == id}) {
                    self.performSegue(withIdentifier: "pushDetailVc", sender: obj)
                }
            }
            cell.btnDeleteClicked = { id in
                self.showAlertForRemoveConfirmation(strId: id)
            }
            return cell
        }.disposed(by: disposeBag)
    }
}

//MARK: - Navigation
extension DiaryListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushDetailVc" {
            if let detailVc = segue.destination as? DiaryDetailViewController,
                let diaryData = sender as? DiaryData {
                detailVc.diaryData = diaryData
                detailVc.shouldRefresh = { result in
                    if result {
                        self.viewModel.fetchDataFromDB()
                    }
                }
            }
        }
    }
}
