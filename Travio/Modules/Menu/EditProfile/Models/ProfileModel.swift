

import Foundation

struct Profile: Codable {
    let fullName: String
    let email: String
    let role: String
    let ppUrl: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case email
        case role
        case ppUrl = "pp_url"
        case createdAt = "created_at"
    }
}

struct ProfileInput {
    var fullName: String
    var email: String
    var ppUrl: String
}
