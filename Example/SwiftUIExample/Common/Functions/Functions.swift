//
//  Functions.swift
//  SwiftUIExample
//
//  Created by Seoksoon Jang on 2019/12/02.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import Combine

func ReplaceUrlResolution(from url: String,
                          targetWidth: String,
                          targetHeight: String) -> String {
    var copyUrl = url
    let components = copyUrl
        .components(separatedBy: "id/")
        
    if components.count > 1 {
        let subComponents = components[1]
            .components(separatedBy:"/")
        
        if subComponents.count >= 3 {
           let sourceWidth = subComponents[1]
           let sourceHeight = subComponents[2]
        
            copyUrl = copyUrl
                .replacingOccurrences(of: sourceWidth,
                                      with: targetWidth)
            copyUrl = copyUrl
                .replacingOccurrences(of: sourceHeight,
                                      with: targetHeight)
            
        } else {
            return url
        }
    } else {
        return url
    }
    
    return copyUrl
}


// MARK: - Combine Functions
import Combine

func ReadJSON<T: Codable>(fileName: String) throws -> AnyPublisher<[T], IOError> {
    if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path),
                                options: .mappedIfSafe)
            
            return Just(data)
                .decode(type: [T].self, decoder: JSONDecoder())
                .mapError { IOError.error($0.localizedDescription) }
                .eraseToAnyPublisher()
        } catch {
            throw IOError.error("json decoding error")
        }
    }
    
    return MakeErrorPublisher(msg: "ReadJso File Error")
    
}

func MakeErrorPublisher<T>(msg: String) -> AnyPublisher<[T], IOError> where T: Codable {
    Fail(error: IOError.error(msg)).eraseToAnyPublisher()
}

func ReadRawFile(fileName: String) throws -> String {
    if let path = Bundle.main.path(forResource: fileName, ofType: "txt") {
        do {
            return String(decoding:
                try Data(contentsOf: URL(fileURLWithPath: path),
                         options: .mappedIfSafe),
                   as: UTF8.self)
        } catch {
            throw IOError.error("tag decoding error")
        }
    } else {
            throw IOError.error("tag decoding error")
    }
}

// MARK: - UserDefault
func UnArchiveObjectsFromUserDefault<T>(key: String) -> [T] {
    if let data = UserDefaults.standard.object(forKey: key) as? Data {
        if let res = NSKeyedUnarchiver.unarchiveObject(with: data) as? [T] {
            return res
        } else {
            return []
        }
    } else {
        return []
    }
}
