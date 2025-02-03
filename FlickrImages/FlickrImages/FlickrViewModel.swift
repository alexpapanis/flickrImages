//
//  FlickrViewModel.swift
//  FlickrImages
//
//  Created by Alexandre Papanis on 2/3/25.
//

import SwiftUI

class FlickrViewModel: ObservableObject {
    @Published var images: [FlickrImage] = []
    
    @MainActor
    func fetchFlickrImages(searchText: String) async throws -> Result<Bool, Error> {
        
        let urlString: String = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=" + searchText
        
        if let url = URL(string: urlString) {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let response = try decoder.decode(FlickrModel.self, from: data)
                if let items = response.items {
                    images = items    
                }
            } catch {
                return .failure(error)
            }
        }
        return .success(true)
    }
    
}
