

import Alamofire
import Foundation

class LoginViewModel {
    typealias LoginHandler = (String, Bool) -> Void

    func login(_ input: Login, callback: @escaping LoginHandler) {
        if !fieldValidation(email: input.email, pass: input.password) {
            callback("Fields can not be empty", false)
            return
        }

        if !isValidEmail(input.email) {
            callback("Wrong email format.", false)
            return
        }

        if !passwordIsValid(pass: input.password) {
            callback("Password must be in 6-12.", false)
            return
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

        func fieldValidation(email: String, pass: String) -> Bool {
            if email.isEmpty {
                return false
            } else if pass.isEmpty {
                return false
            }
            return true
        }

        let params: Parameters = [
            "email": input.email,
            "password": input.password,
        ]

        NetworkManager.shared.request(TravioRouter.login(params: params), responseType: LoginResponse.self) { result in
            switch result {
            case .success:
                callback("You're logged in successfully.", true)

            case .failure(let error):
                callback(error.localizedDescription, false)
            }
        }
    }
}

