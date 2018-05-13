//
//  Router.swift
//  HandleError
//
//  Created by Vladimir Shutov on 13.05.2018.
//  Copyright © 2018 65apps. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class Router: ReactiveCompatible {
    var view: UIViewController!
    
    func presentErrorWithMessage(_ message: String?) {
        let alertVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Alert") as! AlertViewController
        alertVC.errorMessage = message
        view.present(alertVC, animated: true)
    }
}

extension Reactive where Base: Router {
    
    var errorMessage: Binder<String?> {
        return Binder(self.base) { router, text in
            router.presentErrorWithMessage(text)
        }
    }
    
    
}
