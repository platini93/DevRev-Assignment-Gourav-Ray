import Foundation

struct GenreResponse: Codable {
    let genres: [Genre]?
}

struct Genre: Codable {
    let id: Int?
    let name: String?
}


