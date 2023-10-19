

import Foundation

struct NewPassInput {
    let newPass: String
    let newPassConfirm: String
}

struct Section {
    let title: String
    let items: [Item]
}

struct Item {
    let type: ItemType
}

enum ItemType {
    case textInput(String, String)
    case switchItem(String)
}
