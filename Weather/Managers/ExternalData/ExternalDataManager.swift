//
//  ExternalDataManager.swift
//  Weather
//
//  Created by Juan Dario Delgado Lasso on 25/01/23.
//


import Foundation
import Alamofire

enum APIErrors {
    case api
    case decoding(String)
    case networkConnectionLost
    case notConnectedToInternet
}

enum ExternalDataResult<T> where T: Decodable {
    case success(T)
    case failure(APIErrors)
}

class SessionManager {
    
    static let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.httpAdditionalHeaders = AF.sessionConfiguration.httpAdditionalHeaders
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        return Session(configuration: configuration)
    }()
}

protocol ExternalDataManagerProtocol {
    static func execute<T>(request: URLRequestConvertible,_ result: @escaping (ExternalDataResult<T>) -> Void) where T: Decodable
}

class ExternalDataManager: ExternalDataManagerProtocol {
    
    class func execute<T>(
        request: URLRequestConvertible,
        _ result: @escaping (ExternalDataResult<T>) -> Void
    ) where T: Decodable {
        SessionManager.session.request(request).validate(
            statusCode: HTTPStatus.ok.code..<HTTPStatus.badRequest.code
        ).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let jsonObject = try JSONDecoder().decode(T.self, from: data)
                    result(.success(jsonObject))
                } catch let error {
                    result(.failure(getError(error)))
                }
            case .failure(let error):
                result(.failure(getError(error.underlyingError)))
            }
        }
    }
    
    class func getError(_ error: Error?) -> APIErrors {
        let apiErrors: APIErrors
        if let decodingError = error as? DecodingError {
            let reason: String
            switch decodingError {
            case .typeMismatch(let type, let context):
                reason = "type: \(type), context: \(context)"
            case .valueNotFound(let value, let context):
                reason = "value: \(value), context: \(context)"
            case .keyNotFound(let key, let context):
                reason = "key: \(key), context: \(context)"
            case .dataCorrupted(let context):
                reason = "context: \(context)"
            default:
                reason = decodingError.localizedDescription
            }
            apiErrors = .decoding(reason)
        } else if let urlError = error as? URLError {
            print("mv: \(urlError.code)")
            switch urlError.code {
            case .notConnectedToInternet:
                apiErrors = .notConnectedToInternet
            case .networkConnectionLost:
                apiErrors = .networkConnectionLost
            default:
                apiErrors = .api
            }
        } else {
            apiErrors = .api
        }
        return apiErrors
    }
}
