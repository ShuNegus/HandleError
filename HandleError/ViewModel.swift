//
//  ViewModel.swift
//  HandleError
//
//  Created by IVAN CHIRKOV on 11.05.2018.
//  Copyright © 2018 65apps. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ViewModel: ViewModelType {
    
    struct Input {
        let logIn: ControlEvent<Void>
        let disposeBag: DisposeBag
    }
    
    struct Output {
        let authError: Driver<String?>
    }
    
    var router: Router!
    
    private let authService: AuthService
    
    private let authErrorTracker = ErrorTracker<Errors.Auth>()
    private let serverErrorTracker = ErrorTracker<Errors.ServerError>()
    
    init() {
        authService = AuthServiceImpl()
    }
    
    func transform(input: Input) -> Output {
        
        input.logIn
            .flatMap({ [unowned self] _ in
                return self.authService.auth(with: "", password: "")
                    .trackError(self.authErrorTracker)
                    .trackError(self.serverErrorTracker)
                    .asDriver(onErrorJustReturn: false)
            })
            .subscribe()
            .disposed(by: input.disposeBag)
    
        serverErrorTracker
            .map({ ($0.failureReason, $0.recoverySuggestion) })
            .drive(router.rx.errorPresentable)
            .disposed(by: input.disposeBag)
        
        return Output(
            authError: authErrorTracker.map({ $0.failureReason})
        )
    }
    
}
