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
    // MARK: - Model
    @Published private var model: SpotlightSearchModel
    
    // MARK: - Variables
    @Published var searchingText: String = ""

    public var didSearchKeyword: ((String) -> Void)? = nil
    public var founds: [SpotlightItem] {
        model.founds
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    public init(initialDataSource: [String],
                didSearchKeyword: ((String) -> Void)? = nil) {
        self.model = SpotlightSearchModel(dataSource: initialDataSource)
        self.didSearchKeyword = didSearchKeyword
        
        self.bind()
    }
}

// MARK: - Public Methods
extension SpotlightSearchViewModel {
    public func update(dataSource: [String]) {
        model.dataSource = dataSource.map { SpotlightItem(name:$0) }
    }
}

// MARK: - Private Methods
extension SpotlightSearchViewModel {
    private func bind() {
        
        $searchingText
            .debounce(for: .seconds(0.0),
                      scheduler: DispatchQueue.global(qos:.userInitiated))
            .sink(receiveValue: { [weak self] searchText in
                self?.model.searchItems(forKeyword:searchText)
                self?.didSearchKeyword?(searchText)
            })
            .store(in: &cancellables)
    }
}

#endif
