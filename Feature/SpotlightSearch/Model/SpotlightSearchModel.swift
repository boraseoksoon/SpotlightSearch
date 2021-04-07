//
//  SpotlightSearchModel.swift
//  SwiftUIExample
//
//  Created by Seoksoon Jang on 2019/12/04.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

#if os(iOS)

import Foundation
import Combine

class SpotlightSearchModel {
    public var dataSource: [SpotlightItem]
    public var founds: [SpotlightItem] = []
    
    init(dataSource: [String]) {
        self.dataSource = dataSource.map { SpotlightItem(name:$0) }
    }
}

// MARK: - Private Methods
extension SpotlightSearchModel {
    public func searchItems(forKeyword searchingText: String) -> Void {
        if self.dataSource.count >= 1 {
            let founds = self.dataSource
                .filter {
                    if searchingText == "" {
                        return false
                    } else {
                        return $0
                            .name
                            .lowercased()
                            .contains(searchingText.lowercased())
                    }
            }

            self.founds = founds

        } else {
            guard let url = URL(string:"http://google.com/complete/search?output=toolbar&q=\(searchingText.replacingOccurrences(of: " ", with: ""))")
                else {
                    return
            }
            
            AutoCompleteParser.parse(url: url) { suggestion, error in
                self.founds = suggestion.map { SpotlightItem(name: $0) }
            }
        }
    }

}

#endif
