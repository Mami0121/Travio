

import UIKit

class TravioButton: UIButton {
    var insets: UIEdgeInsets
    init(insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        self.insets = insets
        super.init(frame: .zero)
        setupButton()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButton() {
        backgroundColor = AppColor.primary.color
        titleLabel?.font = AppFont.poppinsSemiBold.withSize(16)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.topLeft, .bottomLeft, .topRight], radius: 16)
    }
}

