//
//  Errors.swift
//  HandleError
//
//  Created by IVAN CHIRKOV on 11.05.2018.
//  Copyright © 2018 65apps. All rights reserved.
//

import Foundation

// Слайд

protocol AppError: Error {}

struct Errors {
    
    /// Ошбики аутентификации/авторизации/регистрации.
    enum Auth: AppError {
        case wrongPassword
        case sessionExpired
    }
    
    /// Сетевые ошибки.
    enum Network: AppError {
        case noInternet
        case serverUnavailable
    }
    
    /// Сервер сообщил об ошибке в ответе запроса.
    /// Обычно, такие ошибки не могут быть выделены отдельным http-кодом.
    enum ServerError: AppError {
        case error(message: String, suggestion: String?)
    }
    
    /// Ошибки кеша.
    enum Cache: Swift.Error {
        case noCache
    }
    
    static func errorWithCode(_ code: Int, message: String, suggestion: String?) -> AppError {
        switch code {
        case 7:
            return Auth.wrongPassword
        default:
            return ServerError.error(message: message, suggestion: suggestion)
        }
    }
    
}

// Слайд

extension Errors.Auth: LocalizedError {
    
    var failureReason: String? {
        switch self {
        case .wrongPassword: return "Неверно введен логин или пароль"
        case .sessionExpired: return "Сессия истекла"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .wrongPassword: return "Вы можете воспользоваться восстановлением пароля"
        case .sessionExpired: return "Требуется повторная авторизация"
        }
    }
}

// Слайд

extension Errors.ServerError: LocalizedError {
    
    var failureReason: String? {
        switch self {
        case .error(let message, _): return message
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .error(_, let suggestion): return suggestion
        }
    }
    
}

extension Errors.Network: LocalizedError {}
extension Errors.Cache: LocalizedError {}
