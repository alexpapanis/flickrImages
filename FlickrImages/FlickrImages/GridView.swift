//
//  ContentView.swift
//  FlickrImages
//
//  Created by Alexandre Papanis on 2/3/25.
//

import SwiftUI

struct GridView: View {
    @State private var searchText = ""
    @State private var searchTask: Task<Void, Error>?
    @ObservedObject private var viewModel: FlickrViewModel
    @Environment(\.isSearching) private var isSearching: Bool
    
    private let columns = [GridItem(.adaptive(minimum: 100, maximum: .infinity), spacing: 3)]
    
    init(viewModel: FlickrViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                if(isSearching) {
                    ProgressView()
                } else {
                    LazyVGrid(columns: columns, spacing: 3) {
                        ForEach(viewModel.images, id: \.self) { image in
                            Text(image.title ?? "")
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Search Flickr Images")
            .searchable(text: $searchText, prompt: "Find images")
            .onChange(of: searchText) {
                
                searchTask?.cancel()
                searchTask = Task {
                    try await Task.sleep(for: .seconds(0.5))
                    await fetchImages()
                }
            }
        }
        .task {
            await fetchImages()
        }
    }
    
    private func fetchImages() async {
        do {
            let results = try await viewModel.fetchFlickrImages(searchText: searchText)
            switch results {
            case .success(let images):
                print(images)
            case .failure(let error):
                print(error)
            }
        } catch {
            print(error)
        }
    }
}

#Preview {
    GridView(viewModel: FlickrViewModel())
}
