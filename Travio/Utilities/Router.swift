

import Alamofire
import Foundation

enum TravioRouter {
    case login(params: Parameters)
    case register(params: Parameters)
    case refresh(params: Parameters)
    case getAllPlaces
    case getUserPlaces
    case getPopularPlaces(limit: Int)
    case getNewPlaces(limit: Int)
    case getPlaceById(id: String)
    case getGalleryByPlaceId(id: String)
    case postGalleryByPlaceId(params: Parameters)
    case getAllVisits(page: Int = 1, limit: Int = 100)
    case postPlace(params: Parameters)
    case postVisit(params: Parameters)
    case uploadImage(imageData: [Data])
    case deleteVisitById(id: String)
    case getVisitByPlace(id: String)
    case getProfileInfo
    case putEditProfile(params: Parameters)
    case putChangePassword(params: Parameters)

    var baseURL: URL {
        URL(string: "https://api.iosclass.live")!
    }

    var path: String {
        switch self {
        case .login:
            return "/v1/auth/login"
        case .register:
            return "/v1/auth/register"
        case .refresh:
            return "/v1/auth/refresh"
        case .getAllPlaces:
            return "/v1/places"
        case .getUserPlaces:
            return "v1/places/user"
        case .getPopularPlaces:
            return "/v1/places/popular"
        case .getNewPlaces:
            return "/v1/places/last"
        case .getPlaceById(let placeId):
            return "/v1/places/\(placeId)"
        case .getGalleryByPlaceId(let placeId):
            return "/v1/galleries/\(placeId)"
        case .postGalleryByPlaceId:
            return "/v1/galleries"
        case .getAllVisits:
            return "/v1/visits"
        case .postPlace:
            return "/v1/places"
        case .postVisit:
            return "/v1/visits"
        case .uploadImage:
            return "/upload"
        case .deleteVisitById(let visitId):
            return "/v1/visits/\(visitId)"
        case .getVisitByPlace(let placeId):
            return "/v1/visits/user/\(placeId)"
        case .getProfileInfo:
            return "/v1/me"
        case .putEditProfile:
            return "/v1/edit-profile"
        case .putChangePassword:
            return "/v1/change-password"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .login, .register, .refresh, .postPlace, .postVisit, .uploadImage, .postGalleryByPlaceId:
            return .post
        case .getAllPlaces, .getUserPlaces, .getPopularPlaces, .getNewPlaces, .getPlaceById, .getGalleryByPlaceId, .getAllVisits, .getVisitByPlace, .getProfileInfo:
            return .get
        case .deleteVisitById:
            return .delete
        case .putEditProfile, .putChangePassword:
            return .put
        }
    }

    var parameters: Parameters? {
        switch self {
        case .login(let parameters):
            return parameters
        case .register(let parameters):
            return parameters
        case .refresh(let parameters):
            return parameters
        case .getProfileInfo:
            return nil
        case .putEditProfile(let parameters):
            return parameters
        case .getAllPlaces:
            return nil
        case .getUserPlaces:
            return nil
        case .getPopularPlaces(let limit):
            return ["limit": limit]
        case .getNewPlaces(let limit):
            return ["limit": limit]
        case .getPlaceById:
            return nil
        case .getGalleryByPlaceId:
            return nil
        case .postGalleryByPlaceId(let parameters):
            return parameters
        case .getAllVisits(let page, let limit):
            return ["page": page, "limit": limit]
        case .postPlace(let parameters):
            return parameters
        case .postVisit(let parameters):
            return parameters
        case .uploadImage:
            return nil
        case .deleteVisitById:
            return nil
        case .getVisitByPlace:
            return nil
        case .putChangePassword(let parameters):
            return parameters
        }
    }

    var headers: HTTPHeaders {
        switch self {
        case .login, .register, .refresh, .getAllPlaces, .getNewPlaces, .getPopularPlaces, .getPlaceById, .getGalleryByPlaceId:
            return [:]
        case .getProfileInfo, .putEditProfile, .getAllVisits, .getUserPlaces, .postPlace, .postGalleryByPlaceId, .deleteVisitById, .getVisitByPlace, .postVisit, .putChangePassword:
            return ["Authorization": "Bearer \(KeychainHelper.loadAccessToken()!)"]
        case .uploadImage:
            return ["Content-Type": "multipart/form-data"]
        }
    }
}

extension TravioRouter {
    var multipartFormData: MultipartFormData {
        let formData = MultipartFormData()
        switch self {
        case .uploadImage(let imageData):
            imageData.forEach { image in
                formData.append(image, withName: "file", fileName: "image.jpg", mimeType: "image/jpeg")
            }
            return formData
        default:
            break
        }
        return formData
    }
}

extension TravioRouter: URLRequestConvertible {
    public func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.headers = headers

        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        return try encoding.encode(urlRequest, with: parameters)
    }
}
