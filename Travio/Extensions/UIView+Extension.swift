

import UIKit

extension UIView {
    func addSubviews(_ view: UIView...) {
        view.forEach { v in
            self.addSubview(v)
        }
    }

    enum GradientType {
        case dark
        case light
    }

    func applyGradient(type: GradientType, view: UIView?) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view!.bounds.width, height: view!.bounds.height)
        gradientLayer.locations = [0.0, 0.5]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)

        switch type {
        case .dark:
            let startColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0).cgColor
            let endColor = UIColor(red: 61/255, green: 61/255, blue: 61/255, alpha: 0.0).cgColor
            gradientLayer.colors = [startColor, endColor]
        case .light:
            let startColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0).cgColor
            let endColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 0.0).cgColor
            gradientLayer.colors = [startColor, endColor]
        }

        self.layer.insertSublayer(gradientLayer, at: 0)
    }

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )

        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }

    func addShadow(shadowColor: UIColor = AppColor.secondary.color,
                   shadowOffset: CGSize = CGSize(width: 0, height: 0),
                   shadowOpacity: Float = 0.15,
                   shadowRadius: CGFloat = 8)
    {
        layer.masksToBounds = false
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }

    func roundCornersWithShadow(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let path = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }

        self.layer.shadowColor = AppColor.secondary.color.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowOpacity = 0.15
        self.layer.shadowRadius = 8
        self.layer.masksToBounds = false
    }
}

