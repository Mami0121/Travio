

import Kingfisher
import SnapKit
import UIKit

class SettingsViewController: UIViewController {
    // MARK: - Properties

    private var selectedViewController: UIViewController?
    private lazy var viewModel: SettingsViewModel = .init()

    private lazy var placeHolderImage: UIImage = {
        let image = UIImage(systemName: "person.circle.fill")
        return image ?? UIImage()
    }()

    private lazy var profilePictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 60
        imageView.contentMode = .scaleAspectFill
        imageView.image = placeHolderImage
        imageView.tintColor = AppColor.primary.color
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsSemiBold.withSize(16)
        label.textAlignment = .center
        label.text = "John Doe"
        label.textColor = AppColor.secondary.color
        return label
    }()

    private lazy var editProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit Profile", for: .normal)
        button.titleLabel?.font = AppFont.poppinsMedium.withSize(12)
        button.addTarget(self, action: #selector(editProfileButtonTapped), for: .touchUpInside)
        let color = UIColor(cgColor: #colorLiteral(red: 0, green: 0.7667202353, blue: 0.9408947229, alpha: 1))
        button.setTitleColor(color, for: .normal)
        return button
    }()

    private lazy var settingsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.showsVerticalScrollIndicator = false
        cv.dataSource = self
        cv.register(SettingsViewCell.self, forCellWithReuseIdentifier: SettingsViewCell.identifier)
        return cv
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsSemiBold.withSize(32)
        label.text = "Settings"
        label.textColor = .white
        return label
    }()

    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        let arrowImage = UIImage(named: "logoutIcon")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(arrowImage, for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var componentsView: ComponentsView = .init()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchProfile()
    }

    // MARK: - Private Methods

    private func setupView() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = AppColor.primary.color

        view.addSubviews(titleLabel,
                         logoutButton,
                         componentsView)

        componentsView.addSubviews(settingsCollectionView,
                                   profilePictureImageView,
                                   fullNameLabel,
                                   editProfileButton)

        setupLayout()
    }

    private func setupLayout() {
        componentsView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(36)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(20)
        }

        logoutButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-24)
            make.width.height.equalTo(30)
        }

        profilePictureImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(24)
            make.width.height.equalTo(120)
        }

        fullNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profilePictureImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }

        editProfileButton.snp.makeConstraints { make in
            make.top.equalTo(fullNameLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }

        settingsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(editProfileButton.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    private func fetchProfile() {
        showSpinner()
        viewModel.getProfile { [weak self] message, confirm in
            if confirm {
                DispatchQueue.main.async {
                    self?.hideSpinner()
                    self?.fullNameLabel.text = self?.viewModel.profile?.fullName
                    let imageUrl = URL(string: self?.viewModel.profile?.ppUrl ?? "")
                    self?.profilePictureImageView.kf.setImage(with: imageUrl, placeholder: self?.placeHolderImage)
                }
            } else {
                self?.showAlert(title: "Error", message: message)
                self?.hideSpinner()
            }
        }
    }

    // MARK: - Actions

    @objc func editProfileButtonTapped() {
        let editProfileVc = EditProfileViewController()
        editProfileVc.modalPresentationStyle = .fullScreen
        editProfileVc.profile = viewModel.profile
        editProfileVc.delegate = self
        present(editProfileVc, animated: true)
    }

    @objc func logoutButtonTapped() {
        let title = "Confirm Logout"
        let message = "Are you sure you want to log out?"

        showConfirmationAlert(title: title, message: message) { [weak self] in
            KeychainHelper.deleteAccessToken()
            KeychainHelper.deleteRefreshToken()
            let loginViewController = LoginViewController()

            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first
            {
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    window.rootViewController = UINavigationController(rootViewController: loginViewController)
                }, completion: nil)
            }
            loginViewController.showAlert(from: self!, title: "Success Logout", message: "You're successfully logged out.") {}
        }
    }
}

// MARK: - Extensions

protocol SettingsViewControllerDelegate: AnyObject {
    func didFetchProfile()
    func didShowAlert(title: String, message: String)
}

extension SettingsViewController: SettingsViewControllerDelegate {
    func didFetchProfile() {
        fetchProfile()
    }

    func didShowAlert(title: String, message: String) {
        showAlert(title: title, message: message)
    }
}

extension SettingsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width - 32
        let cellHeight: CGFloat = 54

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = 12
        return UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
            case 0:
                selectedViewController = SecurityViewController()
            case 1:
                selectedViewController = ListViewController()

                if let listVC = selectedViewController as? ListViewController {
                    listVC.selectedSectionType = .added
                }
            case 2:
                selectedViewController = HelpViewController()
            case 3:
                selectedViewController = WebViewController()

                if let webVC = selectedViewController as? WebViewController {
                    webVC.titleWeb = "About"
                    webVC.url = "https://api.iosclass.live/about"
                }
            case 4:
                selectedViewController = WebViewController()

                if let webVC = selectedViewController as? WebViewController {
                    webVC.titleWeb = "Terms of Use"
                    webVC.url = "https://api.iosclass.live/terms"
                }

            default:
                selectedViewController = nil
        }

        if let selectedViewController = selectedViewController {
            navigationController?.pushViewController(selectedViewController, animated: true)
        }
    }
}

extension SettingsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingsViewCell.identifier, for: indexPath) as? SettingsViewCell else {
            return UICollectionViewCell()
        }

        let item = viewModel.item(at: indexPath.row)
        cell.configure(with: item)

        return cell
    }
}
