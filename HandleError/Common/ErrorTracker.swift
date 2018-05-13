//
//  ErrorTracker.swift
//
//  Created by IVAN CHIRKOV on 16.11.2017.
//  Copyright © 2017 65apps. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ErrorTracker<T: Swift.Error>: SharedSequenceConvertibleType {
    typealias SharingStrategy = DriverSharingStrategy
    private let _subject = PublishSubject<T>()
    
    func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.E> {
        return source.asObservable().do(onError: onError)
    }
    
    func asSharedSequence() -> SharedSequence<SharingStrategy, T> {
        return _subject.asObservable().asDriverOnErrorJustComplete()
    }
    
    func asObservable() -> Observable<T> {
        return _subject.asObservable()
    }
    
    func onError(_ error: Swift.Error) {
        if let error = error as? T {
            _subject.onNext(error)
        }
    }
    
    deinit {
        _subject.onCompleted()
    }
}

extension ObservableConvertibleType {
    func trackError<ErrorType>(_ errorTracker: ErrorTracker<ErrorType>) -> Observable<E> {
        return errorTracker.trackError(from: self)
    }
}
