


import Foundation

class NotificationCenterManager {
    static let shared = NotificationCenterManager()

    private init() {}

    func postNotification(name: NSNotification.Name) {
        NotificationCenter.default.post(name: name, object: nil)
    }

    func addObserver(observer: Any, selector: Selector, name: NSNotification.Name) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: nil)
    }

    func removeObserver(observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }
}
