

import Foundation

struct Register {
    var fullName: String
    var email: String
    var password: String
}

struct Login {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let accessToken: String
    let refreshToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken
        case refreshToken
    }
}

