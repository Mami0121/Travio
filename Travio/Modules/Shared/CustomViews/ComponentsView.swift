

import UIKit

class ComponentsView: UIView {
    var insets: UIEdgeInsets
    init(insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        self.insets = insets
        super.init(frame: .zero)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = AppColor.background.color
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: .topLeft, radius: 80)
    }
}

