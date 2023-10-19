

import SnapKit
import UIKit

protocol MainCollectionViewCellDelegate: AnyObject {
    func didSelectPlace(_ place: Place)
    func didTapSeeAllButton(in cell: MainCollectionViewCell)
}

class MainCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties

    weak var delegate: MainCollectionViewCellDelegate?

    private var places: [Place] = []
    static let reuseIdentifier = "MainIdentifier"

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.secondary.color
        label.font = AppFont.poppinsMedium.withSize(20)
        return label
    }()

    lazy var seeAllButton: UIButton = {
        let button = UIButton()
        button.setTitle("See All", for: .normal)
        button.titleLabel?.font = AppFont.poppinsMedium.withSize(14)
        button.addTarget(self, action: #selector(seeAllButtonTapped), for: .touchUpInside)
        button.setTitleColor(AppColor.primary.color, for: .normal)
        return button
    }()

    private lazy var placesCollectionView: UICollectionView = {
        var flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 16
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(PlaceViewCell.self, forCellWithReuseIdentifier: PlaceViewCell.reuseIdentifier)
        return cv
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    // MARK: - Private Methods

    private func setupView() {
        contentView.addSubviews(placesCollectionView, titleLabel, seeAllButton)
        setupConstraints()
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(placesCollectionView.snp.top)
        }
        seeAllButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(placesCollectionView.snp.top)
        }

        placesCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Public Methods

    func configure(with places: [Place], title: String) {
        titleLabel.text = title
        self.places = places
        placesCollectionView.reloadData()
    }

    // MARK: - Actions

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let buttonBounds = seeAllButton.convert(seeAllButton.bounds, to: self)
        let expandedBounds = buttonBounds.insetBy(dx: -10, dy: -10)
        if expandedBounds.contains(point) {
            return seeAllButton
        }
        return super.hitTest(point, with: event)
    }

    @objc private func seeAllButtonTapped() {
        delegate?.didTapSeeAllButton(in: self)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = collectionView.bounds.width - 100
        let cellHeight: CGFloat = 180
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = 24
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPlace = places[indexPath.row]
        delegate?.didSelectPlace(selectedPlace)
    }
}

// MARK: - UICollectionViewDataSource

extension MainCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return places.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaceViewCell.reuseIdentifier, for: indexPath) as? PlaceViewCell else {
            return UICollectionViewCell()
        }
        let place = places[indexPath.row]
        cell.configure(with: place)
        return cell
    }
}
