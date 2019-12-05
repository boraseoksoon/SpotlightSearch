//
//  ItemListViewModel.swift
//  Spotlight
//
//  Created by boraseoksoon on 11/18/2019.
//  Copyright (c) 2019 boraseoksoon. All rights reserved.
//

import Combine
import SwiftUI

class ItemListViewModel: ObservableObject {
    @Published var showingAlert: Bool = false
    @Published var errorMessage: String = ""
    
    @Published var searchedItems: [Photo] = []
    
    var searchText: String = "" {
        didSet {
            DispatchQueue.global().async {
                let res = self.model.search(from: self.items,
                                            forKeyword: self.searchText)
                
                DispatchQueue.main.async {
                    self.searchedItems = res
                }
            }
        }
    }

    /// Original Data. Do not mutate unless it is fetched automatically.
    private var items: [Photo] = [] {
        didSet {
            DispatchQueue.global().async {
                let res = self.model.search(from: self.items,
                                            forKeyword: self.searchText)
                
                DispatchQueue.main.async {
                    self.searchedItems = res
                }
            }
        }
    }

    private let itemId = PassthroughSubject<Int?, CombineNetworkError>()
    private var cancellables = Set<AnyCancellable>()
    
    private var _searchableItems: [String] = []
    public var searchableItems: [String] {
        get {
            return _searchableItems
        }
        set {
            _searchableItems = newValue
        }
    }
    
    private var _images: [UIImage] = []
    public var images: [UIImage] {
        get {
            return _images
        }
        set {
            _images = newValue
        }
    }

    private let model: ItemListModel
    // MARK: - Initializers
    init(model: ItemListModel = ItemListModel(network: CombineNetwork())) {
        self.model = model
        
        self.bind(model: model)
        
        do {
            self.searchableItems = try ReadRawFile(fileName: "authors")
                .components(separatedBy: "!!!")
        } catch {
            fatalError("search data read failed!")
        }
    }
}

// MARK: - Public methods
extension ItemListViewModel {
    public func appearItem(id: Int?) -> Void {
        guard let id = id else { return }
        self.itemId.send(id)
    }
}

// MARK: - Private methods
extension ItemListViewModel {
    private func bind(model: ItemListModel) {
        
        itemId
            .map { model.getPage(items: self.items, id: $0) }
            .filter { $0 != nil }
            .eraseToAnyPublisher()
            .prepend(nil)
            .flatMap(model.fetchItems)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: {
                    guard case .failure(let error) = $0 else { return }
                    self.items = []
                    self.showingAlert = true
                    self.errorMessage = error.message ?? "Unknown error"
                },
                receiveValue:  { items in
                    self.items += items
   
                    self.downloadImages(from:items)
                }
            )
            .store(in: &cancellables)
    }
    
    private func downloadImages(from items: [Photo]) -> Void {
        DispatchQueue.global().async {
            items.forEach { item in
                URL(string: item.imageURL ?? "")?
                    .loadImage(id: item.id)
                    .receive(on: DispatchQueue.main)
                    .sink(
                        receiveCompletion: { _ in },
                        receiveValue: { [weak self] image in
                            DispatchQueue.main.async {
                                self?.images.append(image)
                            }
                        }
                    )
                    .store(in: &self.cancellables)
            }
        }
    }    
}
