

import Alamofire
import Foundation

class SecurityViewModel {
    var sections: [Section] = []
    typealias CompletionHandler = (String, Bool) -> Void

    init() {
        let changePasswordItems: [Item] = [
            Item(type: .textInput("New Password", "Enter your new password")),
            Item(type: .textInput("New Password Confirm", "Confirm your new password")),
        ]

        let changePasswordSection = Section(title: "Change Password", items: changePasswordItems)

        let privacyItems: [Item] = [
            Item(type: .switchItem("Camera")),
            Item(type: .switchItem("Photo Library")),
            Item(type: .switchItem("Location")),
        ]

        let privacySection = Section(title: "Privacy", items: privacyItems)

        self.sections = [changePasswordSection, privacySection]
    }

    func changePassword(_ input: NewPassInput, callback: @escaping CompletionHandler) {
        if !fieldValidation(pass: input.newPass, passConfirm: input.newPassConfirm) {
            callback("Fields must be fill.", false)
            return
        }

        if input.newPass != input.newPassConfirm {
            callback("Passwords are not matched.", false)
            return
        }

        if !passwordIsValid(pass: input.newPass) {
            callback("The password must be between 6 and 12.", false)
            return
        }

        let param: Parameters = ["new_password": input.newPass]
        NetworkManager.shared.request(TravioRouter.putChangePassword(params: param), responseType: ResponseModel.self) { result in
            switch result {
            case .success(let response):
                callback(response.message, true)
            case .failure:
                callback("An error appear when you change pass.", false)
            }
        }
    }

    private func passwordIsValid(pass: String) -> Bool {
        if pass.count < 6 {
            return false
        } else if pass.count > 12 {
            return false
        }
        return true
    }

    private func fieldValidation(pass: String, passConfirm: String) -> Bool {
        if passConfirm.isEmpty {
            return false
        } else if pass.isEmpty {
            return false
        }
        return true
    }
}

