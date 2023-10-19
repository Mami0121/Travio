

import UIKit

class SettingsViewModel {
    typealias Completion = (String, Bool) -> Void
    var profile: Profile?

    private let settingsItems: [SettingsItem] = [
        SettingsItem(title: "Security Settings", image: UIImage(named: "securitySettings")!),
        SettingsItem(title: "My Added Places", image: UIImage(named: "map")!),
        SettingsItem(title: "Help & Support", image: UIImage(named: "helpSupport")!),
        SettingsItem(title: "About", image: UIImage(named: "about")!),
        SettingsItem(title: "Terms of Use", image: UIImage(named: "termsOfUse")!),
    ]

    func numberOfItems() -> Int {
        return settingsItems.count
    }

    func item(at index: Int) -> SettingsItem {
        return settingsItems[index]
    }

    func getProfile(callback: @escaping Completion) {
        NetworkManager.shared.request(TravioRouter.getProfileInfo, responseType: Profile.self) { result in
            switch result {
            case .success(let response):
                self.profile = response
                callback("Profile fetched successfully", true)
            case .failure:
                callback("An error occurred while fetching data from remote", false)
            }
        }
    }
}
