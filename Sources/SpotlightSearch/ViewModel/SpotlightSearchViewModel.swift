//
//  SpotlightSearchViewModel.swift
//  SwiftUIExample
//
//  Created by Seoksoon Jang on 2019/12/04.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

#if os(iOS)
import Foundation
import Combine

typealias SearchResult = String

public class SpotlightSearchViewModel: ObservableObject {
    // MARK: - Publishes
    @Published var searchingText: String = ""
    public var founds: [String] {
        model.founds
    }
    
    public func update(dataSource: [String]) {
        model.dataSource = dataSource
    }
    
    // MARK: - Model
    @Published private var model: SpotlightSearchModel
    
    // MARK: - Instance Variables
    private var cancellables = Set<AnyCancellable>()
    
    public var didSearchKeyword: ((String) -> Void)? = nil
    
    // MARK: - Initializer
    public init(initialDataSource: [String],
                didSearchKeyword: ((String) -> Void)? = nil) {
        self.model = SpotlightSearchModel(dataSource: initialDataSource)
        
        self.didSearchKeyword = didSearchKeyword
        
        self.bind()
    }
}

// MARK: - Private Methods
extension SpotlightSearchViewModel {
    private func bind() {
        
        $searchingText
            .dropFirst(1)
            .debounce(for: .seconds(0.0),
                      scheduler: DispatchQueue.global())
            .sink(receiveValue: { searchText in
                self.model.searchItems(forKeyword:searchText)
                self.didSearchKeyword?(searchText)
            })
            .store(in: &cancellables)
    }
}

#endif
