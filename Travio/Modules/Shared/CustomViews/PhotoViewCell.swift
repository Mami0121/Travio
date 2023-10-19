

import Foundation
import Kingfisher
import UIKit

class PhotoViewCell: UICollectionViewCell {
    // MARK: - Properties

    weak var delegate: PhotoCellDelegate?
    var collectionViewIndexPath: IndexPath?
    private var imageDownloader: DownloadTask?
    static let reuseIdentifier = "PhotoIdentifier"

    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "addPhoto")
        return imageView
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var removeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.square.fill"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        button.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        return button
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
        contentView.backgroundColor = .white
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 16
        contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
        imageView.layer.cornerRadius = 16
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
        contentView.addSubviews(photoImageView, imageView, removeButton)
        contentView.addShadow()
        setupLayout()
    }

    private func setupLayout() {
        photoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(60)
        }

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        removeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.width.height.equalTo(32)
        }
    }

    // MARK: - Public Methods

    func configure(image: UIImage?) {
        if let image = image {
            imageView.image = image
            imageView.isHidden = false
            removeButton.isHidden = false
        } else {
            imageView.isHidden = true
            removeButton.isHidden = true
        }
    }

    // MARK: - Actions

    @objc private func removeButtonTapped() {
        if let indexPath = collectionViewIndexPath {
            delegate?.photoCellDidTapRemoveButton(at: indexPath)
        }
    }
}

