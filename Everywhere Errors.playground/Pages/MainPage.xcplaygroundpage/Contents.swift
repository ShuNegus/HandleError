import UIKit

struct Response {
    var code: Int
    var content: Data
    var error: NetworkFrameworkError?
}




class BaseService {
    var response: Response {
        return Response(code: 120, content: Data(), error: .internetUnavailable)
    }
}


class View: UIViewController {
    
    func presentAlert(title: String, message: String) {}
    func presentRetryAlert(title: String, message: String) {}
}


class BasePresenter {
    let view = View()
    let authService = AuthentificationService()
}




class AppMetrica {
    static func logError(message: String) {}
}





















enum NetworkFrameworkError: Error {
    case internetUnavailable
    case serverDead
}



























extension NetworkFrameworkError {
    
    var appError: AppError {
        switch self {
        case .internetUnavailable:
            return Errors.Network.noInternet
        case .serverDead:
            return Errors.Network.serverUnavailable
        }
    }
    
}




































//: ## Идентификация ошибки
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
    
    enum SystemError: AppError {
        case error(Error)
    }
    
}




















//: ## Локализация ошибки

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















//: ## Обнаружение ошибки
protocol HandleError {
    func handleServiceError(response: Response) throws -> Data
}

extension HandleError {
    
    func handleServiceError(response: Response) throws -> Data {
        // Парсим ответ, проверям на ошибки
        if let error = response.error {
            throw error.appError
        }
        throw Errors.Auth.wrongPassword
    }
}



































//: ## Уведомление об ошибке
protocol AuthentificationServiceDelegate: class {
    func authService(_ service: AuthentificationService, recived token: String)
    func authService(_ service: AuthentificationService, recived error: AppError)
}

class AuthentificationService: BaseService, HandleError {
    
    weak var delegate: AuthentificationServiceDelegate?
    
    func signInWith(login: String, password: String) {
        let response = self.response
        do {
            
            let content = try handleServiceError(response: response)
            delegate?.authService(self,
                                  recived: String(data: content, encoding: .utf16)!)
            
        } catch let error as AppError {
            
            delegate?.authService(self, recived: error)
            
        } catch {
            
            delegate?.authService(self, recived: Errors.SystemError.error(error))
            
        }
    }
}





































//: ## Обработка ошибки



class ErrorTracker {

    var retryClosure: ((_ title: String, _ message: String) -> Void)?
    var pressentErrorClosure: ((_ title: String, _ message: String) -> Void)?
    
    func trackError(_ error: Error) {
        switch error {
        case let error as Errors.Auth:
            pressentErrorClosure?(error.failureReason!, error.recoverySuggestion!)
        case let error as Errors.ServerError:
            retryClosure?(error.failureReason!, error.recoverySuggestion!)
        default:
            AppMetrica.logError(message: error.localizedDescription)
            pressentErrorClosure?("Ошибка", "Мы ее уже исправляем. Попробуйте еще раз")
        }
    }
    
}













class Presenter: BasePresenter {
    
    var errorTracker: ErrorTracker
    
    override init() {
        errorTracker = ErrorTracker()
        super.init()
        authService.delegate = self
        
        errorTracker.pressentErrorClosure = { [weak self] title, message in
            self?.view.presentAlert(title: title, message: message)
        }
        
        errorTracker.retryClosure = { [weak self] title, message in
            self?.view.presentRetryAlert(title: title, message: message)
        }
    }
    
    func signIn(login: String, password: String) {
        authService.signInWith(login: login, password: password)
    }
}

extension Presenter: AuthentificationServiceDelegate {
    
    func authService(_ service: AuthentificationService, recived token: String) {
        //Ура
    }
    
    func authService(_ service: AuthentificationService, recived error: AppError) {
        errorTracker.trackError(error)
    }
}
