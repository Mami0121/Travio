

import UIKit

enum AppColor {
    case primary
    case secondary
    case background

    var color: UIColor {
        switch self {
        case .primary:
            return UIColor(red: 56/255, green: 173/255, blue: 169/255, alpha: 1.0)
        case .secondary:
            return UIColor(red: 0.239, green: 0.239, blue: 0.239, alpha: 1.0)
        case .background:
            return UIColor(red: 0.973, green: 0.973, blue: 0.973, alpha: 1.0)
        }
    }
}

