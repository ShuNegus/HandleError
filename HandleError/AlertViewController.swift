//
//  AlertViewController.swift
//  HandleError
//
//  Created by Vladimir Shutov on 13.05.2018.
//  Copyright © 2018 65apps. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    
    @IBOutlet weak var reasonMessageLabel: UILabel!
    @IBOutlet weak var suggestionMessageLabel: UILabel!
    
    var reasonMessage: String?
    var suggestionMessage: String?
    
    private let bgColor = UIColor(red: 0, green: 30.0/255, blue: 51.0/255, alpha: 0.7)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        reasonMessageLabel.text = reasonMessage
        suggestionMessageLabel.text = suggestionMessage
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.1, animations: {
            self.view.backgroundColor = self.bgColor
        }, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.1, animations: {
            self.view.backgroundColor = .clear
        }, completion: nil)
    }

    
    @IBAction private func dismiss(_ sender: Any? = nil) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
