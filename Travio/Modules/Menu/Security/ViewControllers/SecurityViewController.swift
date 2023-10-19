

import AVFoundation
import CoreLocation
import Kingfisher
import Photos
import SnapKit
import UIKit

class SecurityViewController: UIViewController, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var cameraPermissionGranted = false
    private var photoLibraryPermissionGranted = false
    private var locationPermissionGranted = false
    private var locationPermissionRequested = false

    // MARK: - Properties

    weak var delegate: SettingsViewControllerDelegate?

    private lazy var viewModel: SecurityViewModel = .init()

    private lazy var componentsView: ComponentsView = .init()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.poppinsSemiBold.withSize(32)
        label.text = "Security Settings"
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

    private lazy var securityCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.headerReferenceSize = CGSizeMake(self.view.frame.width, 36)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.showsVerticalScrollIndicator = false
        cv.dataSource = self
        cv.register(SecuritySettingCell.self, forCellWithReuseIdentifier: SecuritySettingCell.identifier)
        cv.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)
        return cv
    }()

    private lazy var saveButton: TravioButton = {
        let button = TravioButton()
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        observePermissionChanges()
    }

    override func viewDidAppear(_ animated: Bool) {
        let manager = CLLocationManager()
        manager.delegate = self
        super.viewDidAppear(animated)
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if cameraAuthorizationStatus == .authorized {
            SecurityHelper.enableCameraToggle(securityCollectionView)
            cameraPermissionGranted = true
        }
        let photoLibraryAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if photoLibraryAuthorizationStatus == .authorized {
            SecurityHelper.enablePhotoLibraryToggle(securityCollectionView)
            photoLibraryPermissionGranted = true
        }
        let locationAuthorizationStatus = manager.authorizationStatus
        if locationAuthorizationStatus == .authorizedAlways || locationAuthorizationStatus == .authorizedWhenInUse {
            SecurityHelper.enableLocationToggle(securityCollectionView)
            locationPermissionGranted = true
            }

    }

    private func observePermissionChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(requestCameraPermission), name: .AVCaptureDeviceWasConnected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestPhotoLibraryPermission), name: .init("photoLibraryPermissionDidChange"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(requestLocationPermission), name: .init("locationPermissionDidChange"), object: nil)
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc func saveButtonTapped() {
        let newPasswordCell = securityCollectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? SecuritySettingCell

        let newPasswordConfirmCell = securityCollectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as? SecuritySettingCell

        let newPassword = newPasswordCell?.passwordView.textField.text ?? ""
        let newPasswordConfirm = newPasswordConfirmCell?.passwordView.textField.text ?? ""

        let input = NewPassInput(newPass: newPassword, newPassConfirm: newPasswordConfirm)

        showSpinner()

        viewModel.changePassword(input, callback: { [weak self] message, confirm in
            if confirm {
                self?.backButtonTapped()
                self?.delegate?.didShowAlert(title: "Success", message: "User successfully updated.")
                self?.hideSpinner()
            } else {
                self?.showAlert(title: "Error", message: message)
                self?.hideSpinner()
            }
        })
    }

    @objc private func toggleButtonTapped(_ sender: UISwitch) {
        print(sender.tag)
        let permissionType = SecurityHelper.PermissionType(rawValue: sender.tag) ?? .camera

        switch permissionType {
        case .camera:
            if sender.isOn {
                requestCameraPermission()
            } else {
                resetCameraPermission()
            }
        case .photoLibrary:
            if sender.isOn {
                if photoLibraryPermissionGranted {
                    SecurityHelper.enablePhotoLibraryToggle(securityCollectionView)
                } else {
                    requestPhotoLibraryPermission()
                }
            } else {
                SecurityHelper.openPhotoLibrarySettings()
            }
        case .location:
            if sender.isOn {
                if locationPermissionGranted {
                    SecurityHelper.enableLocationToggle(securityCollectionView)
                } else {
                    requestLocationPermission()
                }
            } else {
                SecurityHelper.openLocationSettings()
            }
        }
    }

    @objc public func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if !granted {
                DispatchQueue.main.async {
                    SecurityHelper.openAppSettings()
                }
            }
        }
    }

    @objc public func requestPhotoLibraryPermission() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            if status == .denied || status == .restricted {
                DispatchQueue.main.async {
                    SecurityHelper.openAppSettings()
                }
            } else if status == .authorized {
                if let collectionView = self?.securityCollectionView {
                           SecurityHelper.enablePhotoLibraryToggle(collectionView)
                    }
                self?.photoLibraryPermissionGranted = true
                NotificationCenter.default.post(name: .init("photoLibraryPermissionDidChange"), object: nil)
            }
        }
    }
    
    @objc public func requestLocationPermission() {
        if !locationPermissionGranted {
            let manager = CLLocationManager()
            manager.delegate = self

            switch manager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                DispatchQueue.main.async {
                    self.locationPermissionGranted = true
                    SecurityHelper.enableLocationToggle(self.securityCollectionView)
                }
            case .notDetermined:
                DispatchQueue.global(qos: .background).async {
                    manager.requestWhenInUseAuthorization()
                }
            default:
                DispatchQueue.main.async {
                    SecurityHelper.openAppSettings()
                }
            }
        } else {
            SecurityHelper.enableLocationToggle(securityCollectionView)
        }
    }

    public func resetCameraPermission() {
        if cameraPermissionGranted {
            AVCaptureDevice.requestAccess(for: .video) { _ in
                DispatchQueue.main.async {
                    SecurityHelper.openAppSettings()
                }
            }
        } else {
            SecurityHelper.openAppSettings()
        }
    }

    public func resetPhotoLibraryPermission() {
        if photoLibraryPermissionGranted {
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                if status == .denied || status == .restricted {
                    DispatchQueue.main.async {
                        SecurityHelper.openPhotoLibrarySettings()
                    }
                } else if status == .authorized {
                    self?.photoLibraryPermissionGranted = false
                }
            }
        } else {
            SecurityHelper.openPhotoLibrarySettings()
        }
    }

    public func resetLocationPermission() {
        if locationPermissionGranted {
            let locationManager = CLLocationManager()
            locationManager.requestWhenInUseAuthorization()
        } else {
            SecurityHelper.openAppSettings()
        }
    }

    // MARK: - Private Methods

    private func setupView() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = AppColor.primary.color
        componentsView.addSubviews(securityCollectionView)
        view.addSubviews(backButton,
                         titleLabel,
                         componentsView,
                         saveButton)
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
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(125)
        }
        securityCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(saveButton.snp.top)
            make.top.equalToSuperview().offset(32)
        }
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(54)
        }
    }
}

// MARK: - Extensions

extension SecurityViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width - 48
        let cellHeight: CGFloat = 74

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = 24
        return UIEdgeInsets(top: 0, left: 0, bottom: inset, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

extension SecurityViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.sections[section].items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let permissionType: SecurityHelper.PermissionType
        permissionType = SecurityHelper.PermissionType.permissionType(for: indexPath)

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SecuritySettingCell.identifier, for: indexPath) as? SecuritySettingCell else {
            return UICollectionViewCell()
        }

        let section = viewModel.sections[indexPath.section]
        let item = section.items[indexPath.row]

        cell.configure(with: item)
        cell.privacyView.switchControl.tag = permissionType.rawValue
        cell.privacyView.switchControl.addTarget(self, action: #selector(toggleButtonTapped), for: .valueChanged)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as? SectionHeaderView else {
                return UICollectionReusableView()
            }

            let section = viewModel.sections[indexPath.section]
            headerView.configure(with: section.title)

            return headerView
        }

        return UICollectionReusableView()
    }
}
