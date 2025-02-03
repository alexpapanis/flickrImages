//
//  FlickrImagesTests.swift
//  FlickrImagesTests
//
//  Created by Alexandre Papanis on 2/3/25.
//

import XCTest
@testable import FlickrImages

final class FlickrImagesTests: XCTestCase {

    private var sut: FlickrViewModel!
    
    override func setUp() {
        sut = FlickrViewModel()
    }
    
    override func tearDown() {
        sut = nil
    }

    func test_fetchImagesSuccessfully() async {
        let result = try? await sut.fetchFlickrImages(searchText: "horse")
        XCTAssertTrue((try? result?.get()) != nil)
    }

    // Check if all fetched images have the searched text in their tags array
    func test_fetchSearchedImagesSuccessfully() async {
        let searchText = "horse"
        
        let _ = try? await sut.fetchFlickrImages(searchText: searchText)
        
        let images: [FlickrImage] = sut.images
        
        let imagesWithoutTag = images.first(where: {
            if let tags = $0.tags, !tags.contains(searchText) {
                return true
            }
            return false
        })
        
        XCTAssertTrue(imagesWithoutTag == nil)
    }
    
}
