

import UIKit

class InfoView: UIView {
    var titleView: String = "Default" {
        didSet {
            updateLabel()
        }
    }

    var image: UIImage? = nil {
        didSet {
            updateImage()
        }
    }

    private func updateLabel() {
        infoLabel.text = titleView
    }

    private func updateImage() {
        infoImageView.image = image
    }

    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.secondary.color
        label.font = AppFont.poppinsMedium.withSize(12)
        label.text = "Default"
        return label
    }()

    private lazy var infoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.alpha = 0.7
        return imageView
    }()

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

    private func setupViews() {
        backgroundColor = .white
        layer.cornerRadius = 16
        addShadow()
        addSubviews(infoLabel, infoImageView)
        setupConstraints()
    }

    func addShadow() {
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = AppColor.secondary.color.cgColor
    }

    private func setupConstraints() {
        infoImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        infoLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(infoImageView.snp.trailing).offset(8)
        }
    }
}
