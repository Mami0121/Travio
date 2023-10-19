
import Foundation

enum SectionType: Int, CaseIterable {
    case popular = 0
    case new
    case visits
    case added

    var title: String {
        switch self {
        case .popular:
            return "Popular Places"
        case .new:
            return "New Places"
        case .visits:
            return "Your Visits"
        case .added:
            return "My Added Places"
        }
    }
}

class ListViewModel {
    typealias Completion = (Bool) -> Void

    private var popularPlaces: [Place] = []
    private var newPlaces: [Place] = []
    private var visits: [Visit] = []
    private var userPlaces: [Place] = []

    func getDataSource(for sectionType: SectionType) -> [Place] {
        switch sectionType {
        case .popular:
            return popularPlaces
        case .new:
            return newPlaces
        case .visits:
            let placesFromVisits = visits.map { $0.place }
            return placesFromVisits
        case .added:
            return userPlaces
        }
    }

    func fetchPopularPlaces(callback: @escaping Completion) {
        NetworkManager.shared.request(TravioRouter.getPopularPlaces(limit: 10), responseType: PlacesResponse.self) { result in
            switch result {
            case .success(let response):
                self.popularPlaces = response.data.places
                callback(true)
            case .failure:
                callback(false)
            }
        }
    }

    func fetchNewPlaces(callback: @escaping Completion) {
        NetworkManager.shared.request(TravioRouter.getNewPlaces(limit: 10), responseType: PlacesResponse.self) { result in
            switch result {
            case .success(let response):
                self.newPlaces = response.data.places
                callback(true)
            case .failure:
                callback(false)
            }
        }
    }

    func fetchVisits(callback: @escaping Completion) {
        NetworkManager.shared.request(TravioRouter.getAllVisits(page: 1, limit: 10), responseType: VisitResponse.self) { result in
            switch result {
            case .success(let response):
                self.visits = response.data.visits
                callback(true)
            case .failure:
                callback(false)
            }
        }
    }

    func fetchUserPlaces(callback: @escaping Completion) {
        NetworkManager.shared.request(TravioRouter.getUserPlaces, responseType: PlacesResponse.self) { result in
            switch result {
            case .success(let response):
                self.userPlaces = response.data.places
                callback(true)
            case .failure:
                callback(false)
            }
        }
    }
}
