// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let album = try? newJSONDecoder().decode(Album.self, from: jsonData)

import Foundation

struct AlbumResponse: Codable {
    let pagination: Pagination
    var results: [Album]
}

struct Pagination: Codable {
    let page, pages, perPage, items: Int
    let urls: Urls

    enum CodingKeys: String, CodingKey {
        case page, pages
        case perPage = "per_page"
        case items, urls
    }
}

struct Urls: Codable {
    let last, next: String
}

struct Album: Codable {
    var queue: Int?
    let country, year: String?
    let format, label: [String]?
    let genre, style: [String]?
    let id: Int
    let title: String
    let coverImage: String

    enum CodingKeys: String, CodingKey {
        case country, year, format, label, genre, style, id
        case title
        case coverImage = "cover_image"
    }
}

extension Album {
    func mapToArray(_ album: Album) -> [(String, String)] {
        return [
            ("Genre", toString(album.genre)),
            ("Style", toString(album.style)),
            ("Format", toString(album.format)),
            ("Labels", toString(album.label)),
            ("Country", album.country ?? ""),
            ("Year", album.year ?? "")
        ]
    }
    
    func toString(_ array: Array<String>?) -> String {
        guard let a = array else { return "" }
        return a.joined(separator: ", ")
    }
}
