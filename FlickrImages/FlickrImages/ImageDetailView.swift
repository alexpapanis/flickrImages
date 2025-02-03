//
//  ImageDetailView.swift
//  FlickrImages
//
//  Created by Alexandre Papanis on 2/3/25.
//

import SwiftUI

struct ImageDetailView: View {
    var image: FlickrImage
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let urlString = image.media?.m, let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        case .failure:
                            Image("image_placeholder")
                        default:
                            ProgressView()
                        }
                    }
                }
                VStack {
                    titleText
                    authorText
                    dateText
                    descriptionText
                }.padding()
            }
        }
    }
    
    var titleText: some View {
        HStack(alignment: .top) {
            Image(systemName: "text.page")
            Text("Title: \(image.title ?? "")")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    var descriptionText: some View {
        HStack(alignment: .top) {
            Image(systemName: "text.justify.left")
            Text("Description: \(extractLastPContent(from: image.description ?? "") ?? "")")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    var authorText: some View {
        HStack(alignment: .top) {
            Image(systemName: "person.fill")
            Text("Author: \(image.author ?? "")")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }()
    
    @ViewBuilder
    var dateText: some View {
        HStack(alignment: .top) {
            Image(systemName: "calendar")
            if let publishedDate = image.published {
                Text("Published date: \(publishedDate, formatter: dateFormat)")
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text("Published date: unknown")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    func extractLastPContent(from html: String) -> String? {
        let pattern = #"<p>([^<]+)<\/p>(?!.*<\/p>)"#
        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            let range = NSRange(html.startIndex..., in: html)
            if let match = regex.firstMatch(in: html, options: [], range: range) {
                if let pRange = Range(match.range(at: 1), in: html) {
                    return String(html[pRange]).trimmingCharacters(in: .whitespacesAndNewlines)
                }
            }
        }
        return nil
    }
    
}

#Preview {
    ImageDetailView(image: FlickrImage())
}
