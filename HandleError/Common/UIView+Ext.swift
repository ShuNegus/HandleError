//
//  UIView+Ext.swift
//  HandleError
//
//  Created by Vladimir Shutov on 14.05.2018.
//  Copyright © 2018 65apps. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
}
