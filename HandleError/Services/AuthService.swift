//
//  AuthService.swift
//  HandleError
//
//  Created by IVAN CHIRKOV on 11.05.2018.
//  Copyright © 2018 65apps. All rights reserved.
//

import Foundation
import RxSwift


protocol AuthService {
    func auth(with login: String, password: String) -> Single<Bool>
}

class AuthServiceImpl: AuthService {
    
    func auth(with login: String, password: String) -> Single<Bool> {
        return Single.create(subscribe: { single -> Disposable in
            if arc4random_uniform(2) == 0 {
                single(.error(Errors.Auth.wrongPassword))
            } else {
                single(.error(Errors.ServerError.error(message: "Что-то пошло не так", suggestion: "Повторите попытку позднее")))
            }
            return Disposables.create()
        })
    }
    
}
