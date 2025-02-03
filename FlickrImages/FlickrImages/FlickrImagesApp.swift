//
//  FlickrImagesApp.swift
//  FlickrImages
//
//  Created by Alexandre Papanis on 2/3/25.
//

import SwiftUI

@main
struct FlickrImagesApp: App {
    var body: some Scene {
        let viewModel = FlickrViewModel()
        WindowGroup {
            GridView(viewModel: viewModel)
        }
    }
}
