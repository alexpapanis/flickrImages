//
//  FlickrModel.swift
//  FlickrImages
//
//  Created by Alexandre Papanis on 2/3/25.
//

import Foundation

struct FlickrModel: Codable {
    var items: [FlickrImage]?
}

struct FlickrImage: Codable, Hashable {
    var title: String?
    var link: String?
    var media: FlickrMedia?
    var dateTaken: Date?
    var description: String?
    var published: Date?
    var author: String?
    var authorId: String?
    var tags: String?
}

struct FlickrMedia: Codable, Hashable {
    var m: String?
}
