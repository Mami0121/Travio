

import Foundation

struct UploadResponse: Codable {
    let messageType: String
    let message: String
    let urls: [String]
}
