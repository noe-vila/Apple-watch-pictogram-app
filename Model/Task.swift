//
//  Task.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 24/5/23.
//

import Foundation
import SwiftUI

struct Task: Equatable, Codable, Hashable {
    let id: String
    let imageData: String
    let name: String
    let startDate: Date
    let endDate: Date
    let avgColorData: String
    
    init(id: String = UUID().uuidString, imageData: Data = Data(), name: String = "", startDate: Date = Date(), endDate: Date = Date(), avgColorData: Data = Data()) {
        self.id = id
        self.imageData = imageData.base64EncodedString()
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.avgColorData = avgColorData.base64EncodedString()
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        let imageDataString = try container.decode(String.self, forKey: .imageData)
        self.imageData = imageDataString
        self.name = try container.decode(String.self, forKey: .name)
        self.startDate = try container.decode(Date.self, forKey: .startDate)
        self.endDate = try container.decode(Date.self, forKey: .endDate)
        let avgColorDataString = try container.decode(String.self, forKey: .avgColor)
        self.avgColorData = avgColorDataString
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(imageData, forKey: .imageData)
        try container.encode(name, forKey: .name)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(avgColorData, forKey: .avgColor)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case imageData
        case name
        case startDate
        case endDate
        case avgColor
    }
}

extension UIColor {
    func encodeToData() -> Data {
        var colorData: Data?
        if #available(iOS 12.0, *) {
            do {
                colorData = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)
            } catch {
                print("Failed to encode color data: \(error)")
            }
        } else {
            colorData = NSKeyedArchiver.archivedData(withRootObject: self)
        }
        return colorData ?? Data()
    }
    
    static func decodeFromData(_ data: Data) -> UIColor? {
        if #available(iOS 12.0, *) {
            do {
                let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
                return color
            } catch {
                print("Failed to decode color data: \(error)")
            }
        } else {
            let color = NSKeyedUnarchiver.unarchiveObject(with: data) as? UIColor
            return color
        }
        return nil
    }
}
