//
//  ViewController.swift
//  HandleError
//
//  Created by IVAN CHIRKOV on 11.05.2018.
//  Copyright © 2018 65apps. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var viewModel: ViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }
    
    private func setupBinding() {
        let input = ViewModel.Input(
            logIn: loginButton.rx.tap,
            disposeBag: disposeBag
        )
        
        let output = viewModel.transform(input: input)
        output.authError.drive(onNext: { [unowned self] errorText in
            self.errorLabel.text = errorText
            UIView.animate(withDuration: 1, delay: 0, options: .autoreverse, animations: {
                self.errorLabel.alpha = 1
            }, completion: { _ in
                self.errorLabel.alpha = 0
            })
        }).disposed(by: disposeBag)
    }
    
    @IBAction private func hideKeyboard(_ sebder: Any? = nil) {
        view.endEditing(true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

