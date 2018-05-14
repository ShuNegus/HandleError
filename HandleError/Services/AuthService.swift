//
//  AuthService.swift
//  HandleError
//
//  Created by IVAN CHIRKOV on 11.05.2018.
//  Copyright © 2018 65apps. All rights reserved.
//

import Foundation
import RxSwift
import Moya


protocol AuthService {
    func auth(with login: String, password: String) -> Single<Bool>
}

class AuthServiceImpl: AuthService, HandleError {
    
    let provider = MoyaProvider<HandleErrorApi>(stubClosure: MoyaProvider.immediatelyStub)
    
    func auth(with login: String, password: String) -> Single<Bool> {
        
        return provider.rx.request(arc4random_uniform(2) == 0 ? .authError : .serverError)
            .flatMap(handleServiceError)
            .map(Bool.self, atKeyPath: "isSignIn", using: JSONDecoder())
    }
    
}

enum HandleErrorApi: TargetType {
    case authError
    case serverError
}

extension HandleErrorApi {
    var baseURL: URL { return URL(string: "http://65apps.com")! }
    var path: String { return "" }
    var method: Moya.Method { return .get }
    var task: Task { return .requestPlain }
    var headers: [String: String]? { return nil }
    
    var sampleData: Data {
        switch self {
        case .authError:
            return Data.fromFileName("AuthError", ofType: "json")
        case .serverError:
            return Data.fromFileName("ServerError", ofType: "json")
        }
    }

}

protocol HandleError {
    func handleServiceError(response: Response) -> Single<Response>
}

extension HandleError {
    func handleServiceError(response: Response) -> Single<Response> {
        if let json = (try? response.mapJSON()) as? [String: Any],
            let code = json["code"] as? Int,
            let message = json["message"] as? String {
                let suggestion = json["suggestion"] as? String
                let error = Errors.errorWithCode(code, message: message, suggestion: suggestion)
                return Single.error(error)
        }
        return Single.just(response)
    }
}

