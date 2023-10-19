

import Foundation

struct Image: Codable {
    let id: String
    let placeID: String
    let imageURL: String
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case placeID = "place_id"
        case imageURL = "image_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct ImageData: Codable {
    let count: Int
    let images: [Image]
}

struct ImageResponse: Codable {
    let data: ImageData
    let status: String
}

