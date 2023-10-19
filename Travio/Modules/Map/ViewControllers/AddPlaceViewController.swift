

import UIKit

class AddPlaceViewController: UIViewController {
    // MARK: - Properties

    weak var delegate: MapViewControllerDelegate?

    var coordinate: (latitude: Double, longitude: Double)?
    private var selectedImages: [UIImage] = []

    private lazy var imagePickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        return picker
    }()

    private lazy var addPlaceViewModel: AddPlaceViewModel = {
        let viewModel = AddPlaceViewModel()
        return viewModel
    }()

    private lazy var placeNameTextField: TravioUIView = {
        let view = TravioUIView()
        view.placeholderText = "Please write a place name"
        view.titleView = "Place Name"
        return view
    }()

    private lazy var addPhotosCollectionView: UICollectionView = {
        var flowLayout = UICollectionViewFlowLayout()

        flowLayout.minimumLineSpacing = 16
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.scrollDirection = .horizontal

        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        cv.register(PhotoViewCell.self, forCellWithReuseIdentifier: PhotoViewCell.reuseIdentifier)
        return cv
    }()

    private lazy var addButton: TravioButton = {
        let button = TravioButton()
        button.setTitle("Add Place", for: .normal)
        button.addTarget(self, action: #selector(addPlaceButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var rectangle: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.secondary.color
        view.alpha = 0.3
        view.layer.cornerRadius = 4
        return view
    }()

    private lazy var descriptionTextView: TravioTextView = {
        let view = TravioTextView()
        view.titleView = "Visit Description"

        return view
    }()

    var stateTextField: TravioUIView = {
        let view = TravioUIView()
        view.titleView = "State, Country"
        view.placeholderText = "Istanbul, Turkey"
        return view
    }()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - Private Methods

    private func setupView() {
        view.addSubviews(placeNameTextField, descriptionTextView, stateTextField, rectangle, addButton, addPhotosCollectionView)
        view.backgroundColor = AppColor.background.color
        setupLayout()
    }

    private func setupLayout() {
        rectangle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(86)
            make.height.equalTo(8)
        }
        placeNameTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(74)
        }

        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(placeNameTextField.snp.bottom).offset(16)
            make.leading.equalTo(placeNameTextField.snp.leading)
            make.trailing.equalTo(placeNameTextField.snp.trailing)
            make.height.equalTo(220)
        }

        stateTextField.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(16)
            make.leading.equalTo(descriptionTextView.snp.leading)
            make.trailing.equalTo(descriptionTextView.snp.trailing)
            make.height.equalTo(74)
        }

        addPhotosCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(stateTextField.snp.bottom).offset(16)
            make.bottom.equalTo(addButton.snp.top).offset(-16)
        }

        addButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-8)
            make.height.equalTo(54)
        }
    }

    // MARK: - Public Methods

    // MARK: - Actions

    @objc func addPlaceButtonTapped() {
        showSpinner()

        addPlaceViewModel.uploadImage(images: selectedImages) { [weak self] uploadResult in
            if uploadResult {
                self?.performPostPlaceIfImagesUploaded()
            } else {
                self?.hideSpinner()
            }
        }
    }

    private func performPostGallery() {
        guard let placeId = addPlaceViewModel.getPlaceId(), let urls = addPlaceViewModel.getImageUrls() else {
            return
        }

        addPlaceViewModel.postGallery(with: placeId, urls: urls) { _, _ in }
    }

    private func performPostPlaceIfImagesUploaded() {
        guard let title = placeNameTextField.textField.text,
              let place = stateTextField.textField.text,
              let latitude = coordinate?.latitude,
              let longitude = coordinate?.longitude
        else {
            hideSpinner()
            return
        }

        let description = descriptionTextView.textView.text ?? ""

        let input = PlaceInput(place: place, title: title, description: description, latitude: latitude, longitude: longitude)

        let (isValid, errorMessage) = addPlaceViewModel.fieldValidation(input)

        if isValid {
            addPlaceViewModel.postPlace(input) { [weak self] _, confirm in
                if confirm {
                    self?.performPostGallery()
                    self?.hideSpinner()
                    self?.dismiss(animated: true)
                    self?.delegate?.fetchPlaces()
                    self?.delegate?.showAddedAlert()
                } else {
                    self?.hideSpinner()
                }
            }
        } else {
            showAlert(title: "Validation Error", message: errorMessage)
            hideSpinner()
        }
    }
}

// MARK: - Extensions

protocol PhotoCellDelegate: AnyObject {
    func photoCellDidTapRemoveButton(at indexPath: IndexPath)
}

extension AddPlaceViewController: PhotoCellDelegate {
    func photoCellDidTapRemoveButton(at indexPath: IndexPath) {
        if indexPath.row < selectedImages.count {
            selectedImages.remove(at: indexPath.row)
            addPhotosCollectionView.reloadData()
        }
    }
}

extension AddPlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            let selectedImageIndex = picker.view.tag
            if selectedImageIndex < selectedImages.count {
                selectedImages[selectedImageIndex] = image
            } else {
                selectedImages.append(image)
            }

            addPhotosCollectionView.reloadData()
        }

        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension AddPlaceViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = 270
        let cellHeight: CGFloat = 210

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = 24
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.view.tag = indexPath.row
        present(imagePicker, animated: true, completion: nil)
    }
}

extension AddPlaceViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoViewCell.reuseIdentifier, for: indexPath) as! PhotoViewCell
        cell.delegate = self
        cell.collectionViewIndexPath = indexPath
        if indexPath.row < selectedImages.count {
            cell.configure(image: selectedImages[indexPath.row])
        } else {
            cell.configure(image: nil)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
}
