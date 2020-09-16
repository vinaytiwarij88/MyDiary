//
//  DiaryListViewModel.swift
//  MyDiary
//
//  Created by PCQ224 on 16/09/20.
//  Copyright © 2020 PCQ224. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class DiaryListViewModel: BaseViewModel {
    
    ///`State`
    var state = PublishSubject<ViewModelState<DiaryListViewModel>>()
    
    //MARK: - Variables
    private let viewController: DiaryListViewController
    
    ///`Setup`
    init(_ viewController: DiaryListViewController) {
        self.viewController = viewController
    }
    
    //MARK: - Variables
    var diaryItemList           =  [DiaryData]()
    var formatedDiaryItemList   =  BehaviorRelay<[DiaryGroup]>(value: [])
    
    //MARK: - API Call
    private func getDiaryList() {
        state.onNext(.loading)
        
        Webservice.API.sendRequest(.getDiaryList([:]), type: [DiaryData].self)
            .observeOn(SerialDispatchQueueScheduler(qos: .default))
            .subscribe(onNext: { [weak self] (diaryResponse) in
                
                guard let `self` = self else { return }
                
                if diaryResponse.count > 0 {
                    print(diaryResponse)
                    self.state.onNext(.success(self))
                    self.diaryItemList = diaryResponse
                    self.formatDiaryData(diaryResponse)
                    DatabaseManager.shared.deleteEntity(DataEntity.diaryData.rawValue)
                    self.addDataToDB(diaryResponse)
                    
                } else {
                    self.state.onNext(.failure(.noData))
                }
                
                },
                onError: { [weak self] error in
                guard let `self` = self else { return }
                self.state.onNext(.failure(error as! WebError))
                self.state.onNext(.finish(false))
                    
                },
                       
                onCompleted: { [weak self] in
                guard let `self` = self else { return }
                self.state.onNext(.finish(false))
                    
            }).disposed(by: disposeBag)
    }
    
}

//MARK: - DB Methods
extension DiaryListViewModel {
    func fetchDataFromDB(_ isLocalRefresh: Bool = false) {
        DatabaseManager.shared.fetchQuery(entity: DataEntity.diaryData.rawValue) { (objs) in
            let fetchedData = objs.reduce(into: [DiaryData]()) { (result, data) in
                result.append(DiaryData(data: data))
            }
            if fetchedData.count > 0 {
                diaryItemList = fetchedData
                formatDiaryData(fetchedData)
                
            } else {
                if !isLocalRefresh {
                    getDiaryList()
                } else {
                    viewController.addNodataView()
                    formatedDiaryItemList.accept([])
                }
            }
        }
    }
    
    private func addDataToDB(_ diaryDataArray: [DiaryData]) {
        for obj in diaryDataArray {
            DatabaseManager.shared.AddDiaryData(diaryData: obj)
        }
    }
    
    func deleteDiary(for id : String) {
        DatabaseManager.shared.deleteDiaryById(for: id)
        fetchDataFromDB(true)
    }
}

//MARK: - Helper Methods
extension DiaryListViewModel {
    private func formatDiaryData(_ diaryArray : [DiaryData]) {
        let diaryDataArray = diaryArray.filter({ $0.date != nil }).sorted(by: { $0.date!.compare($1.date!) == .orderedDescending })
        
        var todayData       = [DiaryData]()
        var yesterdayData   = [DiaryData]()
        var oldData         = [DiaryGroup]()
        
        for diaryObj in diaryDataArray {
            if let date = diaryObj.date {
                let diaryType = getType(from : date)
                switch diaryType {
                case .today:
                    todayData.append(diaryObj)
                case .yesterday:
                    yesterdayData.append(diaryObj)
                    
                case .old:
                    let months = oldData.map({ $0.type.title })
                    let index = months.firstIndex(of: diaryType.title)
                    if index == nil {
                        oldData.append(DiaryGroup(type: diaryType, diaryList: [diaryObj]))
                    } else {
                        oldData[index!].diaryList.append(diaryObj)
                    }
                }
            }
        }
        var formatedArray = [DiaryGroup]()
        if todayData.count > 0 {
            formatedArray.append(DiaryGroup(type: .today, diaryList: todayData))
        }
        if yesterdayData.count > 0 {
            formatedArray.append(DiaryGroup(type: .yesterday, diaryList: yesterdayData))
        }
        if oldData.count > 0 {
            formatedArray += oldData
        }
        formatedDiaryItemList.accept(formatedArray)
    }
    
    private func getType(from date : Date) -> DiaryType {
        let calendar = Calendar.current
        let startOfNow = calendar.startOfDay(for: Date())
        let startOfTimeStamp = calendar.startOfDay(for: date)
        let components = calendar.dateComponents([.day], from: startOfTimeStamp, to: startOfNow)
        let day = components.day ?? 0
        
        if abs(day) < 1 {
            return .today
            
        } else if day == 1 {
            return .yesterday
            
        } else {
            let month = DateManager.monthInitial.string(from: date)
            return .old(month)
        }
    }
}
