//
//  ItemListModel.swift
//  Spotlight
//
//  Created by boraseoksoon on 11/18/2019.
//  Copyright (c) 2019 boraseoksoon. All rights reserved.
//

import Foundation
import Combine

struct ItemListModel {
    let network: Fetchable
    
    // MARK: - Initializers
    init(network: Fetchable) {
        self.network = network
    }
}

// MARK: - Public Methods
extension ItemListModel {
    func fetchItems(page: Int?) -> AnyPublisher<[Photo], CombineNetworkError> {
        return network.fetchItems(page: page)
    }
    
    func getPage(items: [Photo], id: Int?) -> Int? {
        let lastRowCount = items.count
        let lastIndex = items.firstIndex { id == Int($0.id) }
        let page = lastRowCount / 75 + 1

        guard (74...) ~= lastRowCount,
            lastRowCount - 1 == lastIndex else {
            return nil
        }
         
        return page
    }
    
    public func search(from items: [Photo],
                       forKeyword searchingText: String) -> [Photo] {
        return items
            .filter {
                if searchingText == "" {
                    return true
                } else {
                    return $0.author
                        .lowercased()
                        .contains(searchingText.lowercased())
                }
        }
    }
}
