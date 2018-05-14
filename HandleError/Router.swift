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
    
    func presentErrorWithMessage(_ reason: String?, suggestion: String?) {
        let alertVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Alert") as! AlertViewController
        alertVC.reasonMessage = reason
        alertVC.suggestionMessage = suggestion
        view.present(alertVC, animated: true)
    }
}

extension Reactive where Base: Router {
    
    var errorPresentable: Binder<(String?, String?)> {
        return Binder(self.base) { router, error  in
            router.presentErrorWithMessage(error.0, suggestion: error.1)
        }
    }
    
    
}
