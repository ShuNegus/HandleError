//
//  ViewModelType.swift
//
//  Created by IVAN CHIRKOV on 16.11.2017.
//  Copyright © 2017 65apps. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
