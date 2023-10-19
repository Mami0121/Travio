

import Foundation
import Kingfisher
import UIKit

class ListViewCell: UICollectionViewCell {
    // MARK: - Properties

    private var imageDownloader: DownloadTask?
    static let reuseIdentifier = "ListIdentifier"

    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = AppColor.primary.color
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color = .white
        indicator.style = .medium
        return indicator
    }()

    private lazy var locationImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "location")?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = AppColor.secondary.color
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsRegular.withSize(14)
        label.textAlignment = .center
        label.textColor = AppColor.secondary.color
        return label
    }()

    private lazy var locationStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 6
        return sv
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsSemiBold.withSize(24)
        label.numberOfLines = 1
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
        contentView.roundCornersWithShadow([.bottomLeft, .topLeft, .topRight], radius: 16)
        contentView.backgroundColor = .white
        contentView.layer.shadowPath = UIBezierPath(rect: contentView.bounds).cgPath

        backgroundImageView.layer.cornerRadius = 16
        backgroundImageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]

        backgroundImageView.addSubviews(indicator)
        locationStackView.addArrangedSubviews(locationImageView, locationLabel)
        contentView.addSubviews(backgroundImageView, titleLabel, locationStackView)
        contentView.sendSubviewToBack(backgroundImageView)
        setupLayout()
    }

    private func setupLayout() {
        indicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        backgroundImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalTo(90)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        locationImageView.snp.makeConstraints { make in
            make.width.equalTo(9)
            make.height.equalTo(12)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(backgroundImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-2)
            make.top.equalToSuperview().offset(16)
        }
        locationStackView.snp.makeConstraints { make in
            make.leading.equalTo(backgroundImageView.snp.trailing).offset(8)
            make.bottom.equalToSuperview().offset(-16)
        }
    }

    // MARK: - Public Methods

    public func configure(with place: Place) {
        locationLabel.text = place.place
        titleLabel.text = place.title
        imageDownloader?.cancel()
        guard let urlStr = place.coverImageUrl else {
            backgroundImageView.image = UIImage(named: "placeholderImage")
            return
        }
        if !urlStr.isValidURL {
            backgroundImageView.image = UIImage(named: "placeholderImage")
            return
        }

        indicator.startAnimating()

        backgroundImageView.kf.setImage(
            with: URL(string: urlStr),
            completionHandler: { [weak indicator] result in

                indicator?.stopAnimating()
                indicator?.removeFromSuperview()
                switch result {
                case .success:
                    break
                case .failure:
                    self.backgroundImageView.image = UIImage(named: "placeholderImage")
                }
            }
        )
    }
}
