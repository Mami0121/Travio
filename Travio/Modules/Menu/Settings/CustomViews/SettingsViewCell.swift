

import Foundation
import Kingfisher
import UIKit

class SettingsViewCell: UICollectionViewCell {
    // MARK: - Properties

    static let identifier = "SettingsCell"

    private lazy var settingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.alpha = 0.7
        return imageView
    }()

    private lazy var settingArrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "settingsArrow"))
        return imageView
    }()

    private lazy var settingLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsLight.withSize(14)
        label.textAlignment = .left
        label.textColor = AppColor.secondary.color
        return label
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Private Methods

    private func setupView() {
        contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        contentView.clipsToBounds = false
        contentView.layer.cornerRadius = 16
        addShadow()

        contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]

        contentView.addSubviews(settingLabel,
                                settingImageView,
                                settingArrowImageView)
        setupLayout()
    }

    private func setupLayout() {
        settingImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        settingLabel.snp.makeConstraints { make in
            make.leading.equalTo(settingImageView.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
        }

        settingArrowImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.equalTo(10)
            make.height.equalTo(16)
        }
    }

    // MARK: - Public Methods

    public func configure(with item: SettingsItem) {
        settingLabel.text = item.title
        settingImageView.image = item.image
    }

    // MARK: - Actions
}

// MARK: - Extensions

