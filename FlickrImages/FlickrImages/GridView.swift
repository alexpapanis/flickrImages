//
//  ContentView.swift
//  FlickrImages
//
//  Created by Alexandre Papanis on 2/3/25.
//

import SwiftUI

struct GridView: View {
    @ObservedObject private var viewModel: FlickrViewModel
    @State private var searchText = ""
    @State private var isSearching: Bool = false
    @State private var searchTask: Task<Void, Error>?
    
    private let columns = [GridItem(.adaptive(minimum: 100, maximum: .infinity), spacing: 3)]
    
    init(viewModel: FlickrViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                if(isSearching) {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else {
                    LazyVGrid(columns: columns, spacing: 3) {
                        ForEach(viewModel.images, id: \.self) { image in
                            NavigationLink(destination: ImageDetailView(image: image)) {
                                ImageView(image: image)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Search Flickr Images")
            .searchable(text: $searchText, prompt: "Find images")
            .onChange(of: searchText) {
                searchTask?.cancel()
                isSearching = true
                searchTask = Task {
                    try await Task.sleep(for: .seconds(0.3))
                    await fetchImages()
                    isSearching = false
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
            case .success( _):
                break
            case .failure(let error):
                print(error)
            }
        } catch {
            print(error)
        }
    }
}

struct ImageView: View {
    let image: FlickrImage

    var body: some View {
        if let urlString = image.media?.m, let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .myImageModifier()
                case .failure:
                    Image("image_placeholder")
                        .myImageModifier()
                default:
                    ProgressView()
                }
            }
        } else {
            Image("image_placeholder")
                .myImageModifier()
        }
    }
}

extension Image {
    func myImageModifier() -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .clipped()
            .aspectRatio(1, contentMode: .fit)
   }
}

#Preview {
    GridView(viewModel: FlickrViewModel())
}
