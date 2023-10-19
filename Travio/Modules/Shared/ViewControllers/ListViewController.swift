

import SnapKit
import UIKit

class ListViewController: UIViewController {
    // MARK: - Properties

    private var dataSource: [Place] = []

    var selectedSectionType: SectionType? {
        didSet {
            titleLabel.text = selectedSectionType?.title
            updateCollectionViewData()
        }
    }

    private lazy var listViewModel: ListViewModel = .init()

    private lazy var backButton: UIButton = {
        let button = UIButton()
        let arrowImage = UIImage(named: "back")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(arrowImage, for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var sortButton: UIButton = {
        let button = UIButton()
        let ascendingImage = UIImage(named: "sortAtoZ")
        let descendingImage = UIImage(named: "sortZtoA")
        var isAscending = true
        button.setImage(ascendingImage, for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        button.tag = isAscending ? 1 : 0

        return button
    }()

    private lazy var listCollectionView: UICollectionView = {
        var flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(ListViewCell.self, forCellWithReuseIdentifier: ListViewCell.reuseIdentifier)
        return cv
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsSemiBold.withSize(32)
        label.textColor = .white
        return label
    }()

    private lazy var componentsView = ComponentsView()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - Private Methods

    private func sortPlaces() {
        dataSource.sort(by: { $0.title < $1.title })
    }

    private func setupView() {
        navigationController?.isNavigationBarHidden = true
        
        view.addSubviews(componentsView,
                         listCollectionView,
                         sortButton,
                         backButton,
                         titleLabel)
        
        view.backgroundColor = AppColor.primary.color

        setupLayout()
    }

    private func setupLayout() {
        sortButton.snp.makeConstraints { make in
            make.top.equalTo(componentsView.snp.top).offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.width.equalTo(26)
            make.height.equalTo(22)
        }

        listCollectionView.snp.makeConstraints { make in
            make.top.equalTo(sortButton.snp.bottom).offset(12)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.width.height.equalTo(32)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.top).offset(-6)
            make.leading.equalTo(backButton.snp.trailing).offset(24)
        }
        componentsView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(128)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func updateCollectionViewData() {
        showSpinner()
        guard let selectedSectionType = selectedSectionType else { return }

        switch selectedSectionType {
        case .popular:
            listViewModel.fetchPopularPlaces { [weak self] success in
                if success {
                    DispatchQueue.main.async {
                        self?.hideSpinner()
                        self?.dataSource = self?.listViewModel.getDataSource(for: selectedSectionType) ?? []
                        self?.sortPlaces()
                        self?.listCollectionView.reloadData()
                    }
                } else { self?.hideSpinner() }
            }
        case .new:
            listViewModel.fetchNewPlaces { [weak self] success in
                if success {
                    DispatchQueue.main.async {
                        self?.hideSpinner()
                        self?.dataSource = self?.listViewModel.getDataSource(for: selectedSectionType) ?? []
                        self?.sortPlaces()
                        self?.listCollectionView.reloadData()
                    }
                } else { self?.hideSpinner() }
            }
        case .visits:
            listViewModel.fetchVisits { [weak self] success in
                if success {
                    DispatchQueue.main.async {
                        self?.hideSpinner()
                        self?.dataSource = self?.listViewModel.getDataSource(for: selectedSectionType) ?? []
                        self?.sortPlaces()
                        self?.listCollectionView.reloadData()
                    }
                } else { self?.hideSpinner() }
            }
        case .added:
            listViewModel.fetchUserPlaces { [weak self] success in
                if success {
                    DispatchQueue.main.async {
                        self?.hideSpinner()
                        self?.dataSource = self?.listViewModel.getDataSource(for: selectedSectionType) ?? []
                        self?.sortPlaces()
                        self?.listCollectionView.reloadData()
                    }
                } else { self?.hideSpinner() }
            }
        }
    }

    // MARK: - Public Methods

    // MARK: - Actions

    @objc func sortButtonTapped(_ sender: UIButton) {
        if sender.tag == 1 {
            let descendingImage = UIImage(named: "sortZtoA")
            sender.setImage(descendingImage, for: .normal)
            sender.tag = 0
            dataSource.sort(by: { $0.title > $1.title })
            listCollectionView.reloadData()
        } else {
            let ascendingImage = UIImage(named: "sortAtoZ")
            sender.setImage(ascendingImage, for: .normal)
            sender.tag = 1
            dataSource.sort(by: { $0.title < $1.title })
            listCollectionView.reloadData()
        }
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Extensions

extension ListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width - 48
        let cellHeight: CGFloat = 90

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailsViewController()
        detailVC.placeId = dataSource[indexPath.row].id
        detailVC.visitButtonIsHidden = false
        detailVC.isFromVisit = false
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListViewCell.reuseIdentifier, for: indexPath) as? ListViewCell else {
            return UICollectionViewCell()
        }
        let place = dataSource[indexPath.item]
        cell.configure(with: place)

        return cell
    }
}
