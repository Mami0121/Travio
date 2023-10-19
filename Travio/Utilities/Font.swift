

import UIKit

enum AppFont: String {
    case poppinsBold = "Poppins-Bold"
    case poppinsSemiBold = "Poppins-SemiBold"
    case poppinsRegular = "Poppins-Regular"
    case poppinsMedium = "Poppins-Medium"
    case poppinsLight = "Poppins-Light"

    func withSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

