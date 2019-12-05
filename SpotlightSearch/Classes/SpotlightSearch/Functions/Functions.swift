//
//  Functions.swift
//  FBSnapshotTestCase
//
//  Created by Seoksoon Jang on 2019/12/05.
//

import Foundation

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

