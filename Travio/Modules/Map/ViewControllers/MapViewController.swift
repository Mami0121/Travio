

import MapKit
import UIKit

class MapViewController: UIViewController {
    // MARK: - Properties

    private var visitedPlaceIDs: Set<String> = []

    private lazy var mapViewModel: MapViewModel = {
        let viewModel = MapViewModel()
        return viewModel
    }()

    private var mapAnnotations: [CustomAnnotation] = []

    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return mapView
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

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        placesCollectionView.delegate = self
        setupView()
        fetchPlaces()
        setupLongPressGesture()
    }

    // MARK: - Private Methods

    private func setupLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        mapView.addGestureRecognizer(longPressGesture)
    }

    private func createAnnotations() -> [CustomAnnotation] {
        var annotations: [CustomAnnotation] = []

        for place in mapViewModel.places {
            let latitude = place.latitude
            let longitude = place.longitude
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let annotation = CustomAnnotation(coordinate: coordinate)
            annotation.title = place.title
            annotations.append(annotation)
        }
        return annotations
    }

    private func updateMapAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(mapAnnotations)
    }

    private func setupView() {
        navigationController?.isNavigationBarHidden = true
        view.addSubviews(mapView, placesCollectionView)
        setupLayout()
    }

    private func setupLayout() {
        mapView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        placesCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
            make.height.equalTo(180)
        }
    }

    // MARK: - Actions

    @objc private func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        let addPlaceVC = AddPlaceViewController()
        if gestureRecognizer.state == .began {
            guard let mapView = gestureRecognizer.view as? MKMapView else { return }
            let touchPoint = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)

            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

            geocoder.reverseGeocodeLocation(location) { placemarks, _ in
                if let placemark = placemarks?.first {
                    if let city = placemark.locality, let country = placemark.country {
                        let address = "\(city), \(country)"
                        addPlaceVC.stateTextField.textField.text = address
                    }
                }
            }

            let coordinateEnum = (latitude: coordinate.latitude, longitude: coordinate.longitude)
            addPlaceVC.coordinate = coordinateEnum

            addPlaceVC.delegate = self

            present(addPlaceVC, animated: true)
        }
    }
}

// MARK: - Extensions

protocol MapViewControllerDelegate: AnyObject {
    func fetchPlaces()
    func showAddedAlert()
}

extension MapViewController: MapViewControllerDelegate {
    func showAddedAlert() {
        showAlert(title: "Success", message: "The place successfully added.")
    }

    func fetchPlaces() {
        showSpinner()
        mapViewModel.fetchPlaces { [weak self] message, confirm in
            if confirm {
                DispatchQueue.main.async {
                    self?.visitedPlaceIDs = Set(self?.mapViewModel.places.map { $0.id } ?? [])
                    self?.placesCollectionView.reloadData()
                    self?.mapAnnotations = self?.createAnnotations() ?? []
                    self?.updateMapAnnotations()
                    self?.hideSpinner()
                }
            } else {
                self?.hideSpinner()
                self?.showAlert(title: "Error", message: message)
            }
        }
    }
}

extension MapViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: placesCollectionView.contentOffset, size: placesCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        if let indexPath = placesCollectionView.indexPathForItem(at: visiblePoint) {
            placesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? CustomAnnotation {
            if let index = mapViewModel.places.firstIndex(where: { $0.title == annotation.title }) {
                let indexPath = IndexPath(item: index, section: 0)
                placesCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)

                let regionRadius: CLLocationDistance = 2500
                let coordinate = CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
                mapView.setRegion(region, animated: true)
            }
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is CustomAnnotation == false {
            return nil
        }

        let senderAnnotation = annotation as! CustomAnnotation

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "CustomAnnotation")

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: senderAnnotation, reuseIdentifier: "CustomAnnotation")
            annotationView!.canShowCallout = true
        }
        let pinImage = UIImage(named: "myCustomMark")

        annotationView!.image = pinImage

        return annotationView
    }
}

extension MapViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = collectionView.bounds.width - 82
        let cellHeight: CGFloat = 180

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let leftInset: CGFloat = 18
        let rightInset: CGFloat = 18
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailsViewController()
        if let place = mapViewModel.getAPlace(at: indexPath.row) {
            detailVC.placeId = place.id
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension MapViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mapViewModel.numberOfPlaces()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaceViewCell.reuseIdentifier, for: indexPath) as? PlaceViewCell else {
            return UICollectionViewCell()
        }

        if let place = mapViewModel.getAPlace(at: indexPath.row) {
            cell.configure(with: place)
        }

        return cell
    }
}
