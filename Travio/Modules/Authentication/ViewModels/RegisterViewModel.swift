

import Alamofire
import Foundation

class RegisterViewModel {
    typealias RegisterHandler = (String, Bool) -> Void

    func register(_ input: Register, passConfirm: String, callback: @escaping RegisterHandler) {
        if !isValidEmail(input.email) {
            callback("Wrong email format.", false)
            return
        }

        if input.password != passConfirm {
            callback("Passwords are not matched.", false)
            return
        }

        if !passwordIsValid(pass: input.password) {
            callback("The password must be between 6 and 12.", false)
            return
        }

        let params: Parameters = [
            "full_name": input.fullName,
            "email": input.email,
            "password": input.password,
        ]

        NetworkManager.shared.request(TravioRouter.register(params: params), responseType: ResponseModel.self) { result in
            switch result {
            case .success(let response):
                callback(response.message, true)
            case .failure(let error):
                callback(error.localizedDescription, false)
            }
        }
    }

    func passwordIsValid(pass: String) -> Bool {
        if pass.count < 6 {
            return false
        } else if pass.count > 12 {
            return false
        }
        return true
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    func fieldValidation(username: String, email: String, pass: String, passConfirm: String) -> Bool {
        if passConfirm.isEmpty {
            return false
        } else if username.isEmpty {
            return false
        } else if email.isEmpty {
            return false
        } else if pass.isEmpty {
            return false
        }
        return true
    }
}
