
import Alamofire
import Foundation
import UIKit

class AddPlaceViewModel {
    typealias AddPlaceHandler = (String, Bool) -> Void
    typealias UploadImageHandler = (Bool) -> Void

    private var urls: [String] = []
    private var placeId = ""

    func getImageUrls() -> [String]? {
        return urls
    }

    func getPlaceId() -> String? {
        return placeId
    }

    func uploadImage(images: [UIImage]?, callback: @escaping UploadImageHandler) {
        var imagesData: [Data] = []
        guard let images = images, !images.isEmpty else {
            callback(true)
            return
        }

        images.forEach { image in
            guard let imageData = image.convertToData(withFormat: .jpeg(compressionQuality: 0.8)) else {
                return
            }
            imagesData.append(imageData)
        }

        NetworkManager.shared.uploadImage(TravioRouter.uploadImage(imageData: imagesData), responseType: UploadResponse.self) { result in
            switch result {
            case .success(let response):
                self.urls = response.urls
                callback(true)
            case .failure:
                callback(true)
            }
        }
    }

    func fieldValidation(_ input: PlaceInput) -> (Bool, String) {
        if input.place.isEmpty {
            return (false, "State, Country name are required.")
        }

        if input.title.isEmpty {
            return (false, "Place name is required.")
        }

        let placeLength = input.place.count
        if placeLength < 3 {
            return (false, "State, Country name must have at least 3 characters.")
        } else if placeLength > 25 {
            return (false, "State, Country name cannot exceed 25 characters.")
        }

        let titleLength = input.title.count
        if titleLength < 3 {
            return (false, "Place name must have at least 3 characters.")
        } else if titleLength > 25 {
            return (false, "Place name cannot exceed 25 characters.")
        }

        return (true, "")
    }

    func postPlace(_ input: PlaceInput, callback: @escaping AddPlaceHandler) {
        let params: Parameters = [
            "place": input.place,
            "title": input.title,
            "description": input.description ?? "",
            "cover_image_url": urls.first ?? "",
            "latitude": input.latitude,
            "longitude": input.longitude
        ]

        NetworkManager.shared.request(TravioRouter.postPlace(params: params), responseType: ResponseModel.self) { result in
            switch result {
            case .success(let response):
                self.placeId = response.message
                callback(response.message, true)
            case .failure(let error):
                callback(error.localizedDescription, true)
            }
        }
    }

    func postGallery(with placeId: String, urls: [String]?, callback: @escaping AddPlaceHandler) {
        guard let urls = urls, !urls.isEmpty else {
            callback("Images nil", false)
            return
        }

        let dispatchGroup = DispatchGroup()
        var success = true

        for url in urls {
            dispatchGroup.enter()

            let params: Parameters = [
                "place_id": placeId,
                "image_url": url
            ]

            NetworkManager.shared.request(TravioRouter.postGalleryByPlaceId(params: params), responseType: ResponseModel.self) { result in
                switch result {
                case .success:
                    success = true
                case .failure:
                    success = false
                }

                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            callback(success ? "Gallery images posted successfully" : "Error posting gallery images", success)
            NotificationCenterManager.shared.postNotification(name: NSNotification.Name(rawValue: "VisitChanged"))
        }
    }
}

