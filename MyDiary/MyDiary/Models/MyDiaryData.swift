//
//  MyDiaryData.swift
//  MyDiary
//
//  Created by PCQ224 on 16/09/20.
//  Copyright © 2020 PCQ224. All rights reserved.
//

import Foundation
import CoreData

struct DiaryData: Codable {
    let id      : String?
    let title   : String?
    let desc : String?
    let latestDate : String?
    var date    : Date?
    
    enum CodingKeys: String, CodingKey {
        case id         = "id"
        case title      = "title"
        case desc    = "desc"
        case latestDate    = "latestDate"
    }
    
    init(from decoder: Decoder) throws {
        let values  = try decoder.container(keyedBy: CodingKeys.self)
        id      = try values.decodeIfPresent(String.self, forKey: .id)
        title   = try values.decodeIfPresent(String.self, forKey: .title)
        desc = try values.decodeIfPresent(String.self, forKey: .desc)
        latestDate = try values.decodeIfPresent(String.self, forKey: .latestDate)
        
        if let dateString = latestDate {
            date = DateManager.dateStyleServerDate.date(from: dateString)
        }
    }
    
    init(data: NSManagedObject) {
        id      = data.value(forKey: "id") as? String
        title   = data.value(forKey: "title") as? String
        desc = data.value(forKey: "desc") as? String
        latestDate = data.value(forKey: "latestDate") as? String
        
        if let dateString = latestDate {
            date = DateManager.dateStyleServerDate.date(from: dateString)
        }
    }
}
