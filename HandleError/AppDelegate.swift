//
//  AppDelegate.swift
//  HandleError
//
//  Created by IVAN CHIRKOV on 11.05.2018.
//  Copyright © 2018 65apps. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! ViewController
        
        let router = Router()
        router.view = vc
        
        let viewModel = ViewModel()
        viewModel.router = router
        
        vc.viewModel = viewModel
        
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        return true
    }

}

