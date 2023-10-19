

import Foundation

struct Place: Codable {
    let id: String
    let creator: String
    let place: String
    let title: String
    let description: String?
    let coverImageUrl: String?
    let latitude: Double
    let longitude: Double
    let createdAt: String
    let updatedAt: String
}

extension Place {
    enum CodingKeys: String, CodingKey {
        case id
        case creator
        case place
        case title
        case description
        case coverImageUrl = "cover_image_url"
        case latitude
        case longitude
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct PlaceInput {
    let place: String
    let title: String
    let description: String?
    let latitude: Double
    let longitude: Double
}

struct PlacesResponse: Codable {
    let data: PlacesData
    let status: String
}

struct PlacesData: Codable {
    let count: Int
    let places: [Place]
}

struct PlaceResponse: Codable {
    struct Data: Codable {
        let place: Place
    }

    let data: Data
    let status: String
}

