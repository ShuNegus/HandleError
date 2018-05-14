//
//  Data+Ext.swift
//  HandleError
//
//  Created by Vladimir Shutov on 14.05.2018.
//  Copyright © 2018 65apps. All rights reserved.
//

import Foundation

extension Data {
    
    static func fromFileName(_ fileName: String, ofType type: String) -> Data {
        guard
            let filePath = Bundle.main.path(forResource: fileName, ofType: type),
            let fileContent = try? String(contentsOfFile: filePath),
            let fileData = fileContent.data(using: .utf8)
            else {
                return Data()
        }
        return fileData
    }
    
}
