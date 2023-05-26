//
//  SearchViewModel.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 24/5/23.
//

import Foundation
import SwiftUI

struct PictogramResult: Hashable {
    let id: Int
    let image: UIImage
    let imageURL: String
}

class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResults: [PictogramResult] = []
    @Published var isSearching = false
    
    private struct Pictogram: Codable {
        let _id: Int
    }
    
    func performSearch() {
        guard let encodedText = searchText.lowercased().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.arasaac.org/api/pictograms/es/search/\(encodedText)") else {
            return
        }
        
        isSearching = true
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.isSearching = false
                }
                return
            }
            
            do {
                let searchResults = try JSONDecoder().decode([Pictogram].self, from: data)
                                
                DispatchQueue.global().async {
                    let pictogramResults = searchResults.compactMap { (pictogram: Pictogram) -> PictogramResult? in
                        guard let imageUrlString = self.getImageURLString(for: pictogram),
                              let url = URL(string: imageUrlString),
                              let data = try? Data(contentsOf: url),
                              let image = UIImage(data: data) else {
                            return nil
                        }
                        
                        let pictogramResult = PictogramResult(id: pictogram._id, image: image, imageURL: imageUrlString)
                        return pictogramResult
                    }
                    
                    DispatchQueue.main.async {
                        self.isSearching = false
                        self.searchResults = pictogramResults
                    }
                }
            } catch {
                print("Error: \(error)")
                DispatchQueue.main.async {
                    self.isSearching = false
                }
            }
        }
        
        task.resume()
    }
    
    private func getImageURLString(for pictogram: Pictogram) -> String? {
        return "https://api.arasaac.org/api/pictograms/\(pictogram._id)?download=false"
    }
}
