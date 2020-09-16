//
//  DatabaseManager.swift
//  MyDiary
//
//  Created by PCQ224 on 16/09/20.
//  Copyright © 2020 PCQ224. All rights reserved.
//

import UIKit
import CoreData

enum DataEntity: String {
    case diaryData = "MyDiaryData"
}

class DatabaseManager {
    
    // MARK: - ManagedContext
    private let managedContext = AppConstant.appDelegate.persistentContainer.viewContext
    
    // MARK: - Get Instance
    static let shared = DatabaseManager()
    
    // MARK: - Save Data
    func AddDiaryData(diaryData: DiaryData) {
        let entityDesc = NSEntityDescription.entity(forEntityName: DataEntity.diaryData.rawValue, in: self.managedContext)
        let object = NSManagedObject(entity: entityDesc!, insertInto: self.managedContext);
        
        object.setValue(diaryData.title ?? "", forKey: MyDiaryDataModel.TITLE)
        object.setValue(diaryData.id ?? "", forKey: MyDiaryDataModel.ID)
        object.setValue(diaryData.desc ?? "", forKey: MyDiaryDataModel.DESC)
        object.setValue(diaryData.latestDate ?? "", forKey: MyDiaryDataModel.DATE)
        saveData()
    }
    
    // MARK: - Save Data
    func saveData() {
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Fetch Query
    func fetchQuery(entity: String, completionSuccess: (_ response: [NSManagedObject]) -> Void) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        request.returnsObjectsAsFaults = false
        do {
            let result = try managedContext.fetch(request)
            completionSuccess(result as! [NSManagedObject])
        } catch let error as NSError {
            print("Failed fetchSettingsResult error :- \(error.localizedDescription)")
        }
    }
    
    private func getEntityFetchRequest(forEntityName: String, predicateKey: String) -> NSFetchRequest<NSFetchRequestResult> {
        let entity = NSEntityDescription.entity(forEntityName: forEntityName, in: managedContext)
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entity
        return request
    }
    
    //MARK: - Update Data
    func updateData(for id:String, title: String, content: String) {
        let Request = self.getEntityFetchRequest(forEntityName: DataEntity.diaryData.rawValue, predicateKey: "fileName");
        Request.predicate = NSPredicate(format: "id == %@", id)
        guard let fetchedResults = try? managedContext.fetch(Request) as? [NSManagedObject] else { return  }
        if let fetchedObj = fetchedResults.first {
            let date = DateManager.dateStyleServerDate.string(from: Date())
            fetchedObj.setValue(title, forKey: MyDiaryDataModel.TITLE)
            fetchedObj.setValue(content, forKey: MyDiaryDataModel.DESC)
            fetchedObj.setValue(date, forKey: MyDiaryDataModel.DATE)
        }
        self.saveData()
    }
    
    //MARK: - Delete Data
    func deleteDiaryById(for id: String){
        let Request = self.getEntityFetchRequest(forEntityName: DataEntity.diaryData.rawValue, predicateKey: "fileName");
        Request.predicate = NSPredicate(format: "id == %@", id)
        guard let fetchedResults = try? managedContext.fetch(Request) as? [NSManagedObject] else { return  }
        for asset in fetchedResults {
            managedContext.delete(asset)
        }
        self.saveData()
    }
    
    func deleteEntity(_ entity: String) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try managedContext.execute(deleteRequest)
            saveData()
        } catch {
            print ("There was an error deleting DB :- \(entity)")
        }
    }
}
