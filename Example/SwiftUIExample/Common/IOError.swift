//
//  IOError.swift
//  SwiftUIExample
//
//  Created by Seoksoon Jang on 2019/12/04.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

enum IOError: Error {
    case error(String)
    case unknown(String)
    
    var message: String? {
        switch self {
            case .error(let msg):
                return msg
            case let .unknown(msg):
                return msg
        }
    }
}
