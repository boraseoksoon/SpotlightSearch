//
//  SpotlightSearchVM.swift
//  SwiftUIExample
//
//  Created by Seoksoon Jang on 2019/12/04.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

#if os(iOS)
import Foundation
import Combine

typealias SearchResult = String

class SpotlightSearchVM: ObservableObject {
    // MARK: - Publishes
    @Published var searchingText: String = ""
    @Published var founds: [String] = []

    // MARK: - Model
    private let model: SpotlightSearchModel
    
    // MARK: - Instance Variables
    private let searchResultSubject = PassthroughSubject<[SearchResult], SpotlightError>()
    private var cancellables = Set<AnyCancellable>()
    
    var didSearchKeyword: (String) -> Void
    
    // MARK: - Initializer
    init(searchKeywords: [String], didSearchKeyword: @escaping (String) -> Void) {
        self.model = SpotlightSearchModel(
            searchKeywords: searchKeywords,
            searchResultSubject:searchResultSubject
        )
        
        self.didSearchKeyword = didSearchKeyword
        
        self.bind()
    }
}

// MARK: - Private Methods
extension SpotlightSearchVM {
    private func bind() {
        
        $searchingText
            .dropFirst(1)
            .debounce(for: .seconds(0.0),
                      scheduler: DispatchQueue.global())
            .sink(receiveValue: { searchText in
                self.model.searchItems(forKeyword:searchText)
                self.didSearchKeyword(searchText)
            })
            .store(in: &cancellables)

        searchResultSubject
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: {
                    self.founds = $0
            })
            .store(in: &cancellables)
    }
}

#endif
