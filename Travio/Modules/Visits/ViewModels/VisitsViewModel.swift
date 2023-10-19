

import Foundation

class VisitsViewModel {
    typealias Completion = (String, Bool) -> Void
    private var visits: [Visit] = []

    func fetchVisits(completion: @escaping Completion) {
        NetworkManager.shared.request(TravioRouter.getAllVisits(), responseType: VisitResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.visits = response.data.visits
                completion("You've fetched all visits successfully.", true)
            case .failure(let error):
                completion(error.localizedDescription, false)
            }
        }
    }

    func numberOfVisits() -> Int {
        return visits.count
    }

    func getAVisit(at index: Int) -> Visit? {
        return visits[index]
    }
}
