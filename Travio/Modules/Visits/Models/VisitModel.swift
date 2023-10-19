

import Foundation

struct Visit: Codable {
    let id: String
    let placeID: String
    let visitedAt: String
    let createdAt: String
    let updatedAt: String
    let place: Place

    enum CodingKeys: String, CodingKey {
        case id
        case placeID = "place_id"
        case visitedAt = "visited_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case place
    }
}

struct VisitData: Codable {
    let count: Int
    let visits: [Visit]
}

struct VisitResponse: Codable {
    let data: VisitData
    let status: String
}
