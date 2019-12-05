//
//  SpotlightSearchVM.swift
//  SwiftUIExample
//
//  Created by Seoksoon Jang on 2019/12/04.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import Combine

typealias SearchResult = String

class SpotlightSearchVM: ObservableObject {
    // MARK: - Publishes
    @Published var searchingText: String = UserDefaults.standard.string(forKey: KEY_SEARCHING_TEXT) ?? ""
    @Published var founds: [String] = UnArchiveObjectsFromUserDefault(key: KEY_FOUNDS)

    // MARK: - Model
    private let model: SpotlightSearchModel
    
    // MARK: - Instance Variables
    private var didChangeSearchText: (String) -> Void
    private let searchResultSubject = PassthroughSubject<[SearchResult], SpotlightError>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    init(searchKeywords: [String], didChangeSearchText: @escaping (String) -> Void) {
        /// TODO: Fix Userdefault Workaround after Bugs of SwiftUI and Combination settle down.
        UserDefaults.standard.removeObject(forKey: KEY_FOUNDS)
        UserDefaults.standard.removeObject(forKey: KEY_SEARCHING_TEXT)
        
        self.didChangeSearchText = didChangeSearchText
        
        self.model = SpotlightSearchModel(searchKeywords: searchKeywords,
                                    searchResultSubject:searchResultSubject)
        self.bind()
    }
}

// MARK: - Private Methods
extension SpotlightSearchVM {
    private func bind() {
        _ = $searchingText
                .dropFirst(1)
                .debounce(for: .seconds(0.0),
                          scheduler: DispatchQueue.main)
                .sink(receiveValue: {
                    UserDefaults.standard.set($0, forKey: KEY_SEARCHING_TEXT)
                    
                    self.didChangeSearchText($0)
                    self.model.searchItems(forKeyword:$0)
                })
                .store(in: &cancellables)

        searchResultSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                switch $0 {
                    case .failure(let error):
                        print("searchResultSubject error : \(error)")
                    case .finished:
                        break
                }
            }, receiveValue: {
                print("?0")
                let archive = try? NSKeyedArchiver.archivedData(withRootObject: $0,
                                                           requiringSecureCoding: true)
                UserDefaults.standard.set(archive, forKey: KEY_FOUNDS)
            })
            .store(in: &cancellables)
    }
}
