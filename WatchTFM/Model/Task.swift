//
//  Task.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 24/5/23.
//

import Foundation

struct Task: Equatable, Codable, Hashable {
    let imageURL: URL
    let name: String
    let startDate: Date
    let endDate: Date
    
    init(imageURL: URL, name: String, startDate: Date, endDate: Date) {
        self.imageURL = imageURL
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        imageURL = try container.decode(URL.self, forKey: .imageURL)
        name = try container.decode(String.self, forKey: .name)
        startDate = try container.decode(Date.self, forKey: .startDate)
        endDate = try container.decode(Date.self, forKey: .endDate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(imageURL, forKey: .imageURL)
        try container.encode(name, forKey: .name)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
    }
    
    private enum CodingKeys: String, CodingKey {
        case imageURL
        case name
        case startDate
        case endDate
    }
}
