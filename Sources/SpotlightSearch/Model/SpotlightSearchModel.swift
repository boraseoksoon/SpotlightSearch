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

struct SpotlightSearchModel {
    var searchKeywords: [String]
    let searchResultSubject: PassthroughSubject<[SearchResult], SpotlightError>
}

// MARK: - Private Methods
extension SpotlightSearchModel {
    // TODO:
    public func searchItems(forKeyword searchingText: String) -> Void {
        let founds = self.searchKeywords
            .filter {
                if searchingText == "" {
                    return false
                } else {
                    return $0
                        .lowercased()
                        .contains(searchingText.lowercased())
                }
        }

        searchResultSubject.send(founds)
    }

}

#endif
