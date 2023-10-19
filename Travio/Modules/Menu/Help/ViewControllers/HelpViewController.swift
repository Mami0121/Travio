

import SnapKit
import UIKit

class HelpViewController: UIViewController {
    // MARK: - Properties

    private lazy var viewModel: HelpViewModel = .init()

    private lazy var componentsView: ComponentsView = .init()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsSemiBold.withSize(32)
        label.text = "Help & Support"
        label.textColor = .white
        return label
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton()
        let arrowImage = UIImage(named: "back")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(arrowImage, for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var helpCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 12
        layout.headerReferenceSize = CGSizeMake(self.view.frame.width, 100)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.showsVerticalScrollIndicator = false
        cv.dataSource = self
        cv.register(ExpandableCell.self, forCellWithReuseIdentifier: ExpandableCell.identifier)
        cv.register(FAQHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FAQHeaderView.identifier)
        return cv
    }()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - Private Methods

    private func setupView() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = AppColor.primary.color
        componentsView.addSubviews(helpCollectionView)
        view.addSubviews(backButton,
                         titleLabel,
                         componentsView)
        setupLayout()
    }

    private func setupLayout() {
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
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
        }

        helpCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Actions

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Extensions

extension HelpViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let item = viewModel.item(at: indexPath) else {
            return CGSize(width: collectionView.frame.width - 48, height: 54)
        }

        let width = collectionView.frame.width - 48
        let questionHeight = viewModel.heightForText(item.question, font: AppFont.poppinsMedium.withSize(14), width: width - 58)

        var answerHeight: CGFloat = 0.0

        if item.isExpanded {
            answerHeight = viewModel.heightForText(item.answer, font: AppFont.poppinsLight.withSize(10), width: width - 24)
        }

        let cellHeight = 16 + questionHeight + 12 + answerHeight + 16

        return CGSize(width: width, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.toggleItemExpansion(at: indexPath)

        collectionView.performBatchUpdates {
            collectionView.reloadItems(at: [indexPath])
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = 16
        return UIEdgeInsets(top: 0, left: 0, bottom: inset, right: 0)
    }
}

extension HelpViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItemsInSection(section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExpandableCell.identifier, for: indexPath) as? ExpandableCell else {
            return UICollectionViewCell()
        }

        guard let item = viewModel.item(at: indexPath) else {
            return UICollectionViewCell()
        }

        cell.configure(with: item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FAQHeaderView.identifier, for: indexPath) as? FAQHeaderView else {
                return UICollectionReusableView()
            }

            return headerView
        }

        return UICollectionReusableView()
    }
}
