

import Alamofire
import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    enum NetworkError: Error {
        case network(Error)
        case responseDecoding(Error)
    }

    typealias Completion<T: Decodable> = (Result<T, NetworkError>) -> Void

    // MARK: - Public Methods

    func request<T: Decodable>(_ route: TravioRouter, responseType type: T.Type, completion: @escaping Completion<T>) {
        AF.request(route)
            .validate()
            .responseDecodable(of: T.self) { response in
                self.handleResponse(response, completion: completion)
            }
    }

    func uploadImage<T: Decodable>(_ route: TravioRouter, responseType: T.Type, completion: @escaping Completion<T>) {
        AF.upload(multipartFormData: route.multipartFormData, with: route)
            .validate()
            .responseDecodable(of: T.self) { response in
                self.handleResponse(response, completion: completion)
            }
    }

    // MARK: - Private Methods

    private func handleResponse<T: Decodable>(_ response: AFDataResponse<T>, completion: @escaping Completion<T>) {
        switch response.result {
        case .success(let data):
            handleSuccessResponse(data: data, response: response, completion: completion)
        case .failure(let error):
            handleFailureResponse(error: error, response: response, completion: completion)
        }
    }

    private func handleSuccessResponse<T: Decodable>(data: T, response: AFDataResponse<T>, completion: @escaping Completion<T>) {
        if let loginResponse = data as? LoginResponse {
            KeychainHelper.saveAccessToken(loginResponse.accessToken)
        }
        completion(.success(data))
    }

    private func handleFailureResponse<T: Decodable>(error: AFError, response: AFDataResponse<T>, completion: @escaping Completion<T>) {
        if let underlyingError = response.error {
            completion(.failure(.network(underlyingError)))
        } else {
            completion(.failure(.responseDecoding(error)))
        }
    }
}

