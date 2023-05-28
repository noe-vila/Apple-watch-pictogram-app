//
//  Task.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 24/5/23.
//

import Foundation

struct Task: Equatable, Codable, Hashable {
    let id: String
    let imageData: String
    let name: String
    let startDate: Date
    let endDate: Date
    
    init(id: String = UUID().uuidString, imageData: Data = Data(), name: String = "", startDate: Date = Date(), endDate: Date = Date()) {
        self.id = id
        self.imageData = imageData.base64EncodedString()
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        let imageDataString = try container.decode(String.self, forKey: .imageData)
        self.imageData = imageDataString
        self.name = try container.decode(String.self, forKey: .name)
        self.startDate = try container.decode(Date.self, forKey: .startDate)
        self.endDate = try container.decode(Date.self, forKey: .endDate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(imageData, forKey: .imageData)
        try container.encode(name, forKey: .name)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case imageData
        case name
        case startDate
        case endDate
    }
}
