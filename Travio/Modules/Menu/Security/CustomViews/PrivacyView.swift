

import Foundation
import UIKit

class PrivacyView: UIView {
    // MARK: - Properties

    var titleView: String = "Default" {
        didSet {
            updateLabel()
        }
    }

    private func updateLabel() {
        titleLabel.text = titleView
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsMedium.withSize(14)
        label.textColor = AppColor.secondary.color
        return label
    }()

    lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        return switchControl
    }()

    // MARK: - Initialization

    var insets: UIEdgeInsets
    init(insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        self.insets = insets
        super.init(frame: .zero)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func setupViews() {
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
        addShadow()
        addSubviews(titleLabel, switchControl)
        setupLayout()
    }

    private func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }

        switchControl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
}
