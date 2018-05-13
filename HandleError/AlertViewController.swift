//
//  AlertViewController.swift
//  HandleError
//
//  Created by Vladimir Shutov on 13.05.2018.
//  Copyright © 2018 65apps. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    var errorMessage: String? = "Something went wrong."
    
    private let bgColor = UIColor(red: 0, green: 0, blue: 51.0/255, alpha: 0.7)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = errorMessage
        view.backgroundColor = .clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.2, animations: {
            self.view.backgroundColor = self.bgColor
        }, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.2, animations: {
            self.view.backgroundColor = .clear
        }, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        messageLabel.text = sender as? String
    }
    
    @IBAction private func dismiss(_ sender: Any? = nil) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
