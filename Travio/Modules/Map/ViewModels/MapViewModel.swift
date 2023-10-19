

import Foundation

class MapViewModel {
    typealias PlaceHandler = (String, Bool) -> Void
    var places: [Place] = []

    func fetchPlaces(callback: @escaping PlaceHandler) {
        NetworkManager.shared.request(TravioRouter.getAllPlaces, responseType: PlacesResponse.self) { result in
            switch result {
            case .success(let response):
                callback("You're fetch all places successfully.", true)
                self.places = response.data.places
            case .failure(let error):
                callback(error.localizedDescription, false)
            }
        }
    }

    func numberOfPlaces() -> Int {
        return places.count
    }

    func getAPlace(at index: Int) -> Place? {
        return places[index]
    }
}

