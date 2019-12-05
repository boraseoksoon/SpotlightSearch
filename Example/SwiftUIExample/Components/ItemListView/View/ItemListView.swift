//
//  ItemList.swift
//  Spotlight
//
//  Created by boraseoksoon on 11/18/2019.
//  Copyright (c) 2019 boraseoksoon. All rights reserved.
//

import SwiftUI

/// Step1: 😙 import `Spotlight`
import SpotlightSearch

struct ItemListView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    @ObservedObject var viewModel: ItemListViewModel
    @State private var isSearching = false
    @State var showingDetail = false
    
    // MARK: - Initializers
    init(viewModel: ItemListViewModel = ItemListViewModel()) {
        /// This is example view-mdel implemented for demo purpose.
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    var body: some View {
        /// Step2: 😆 Declare `Spotlight` externally.
        SpotlightSearch(searchKeywords:viewModel.searchableItems,
                  isSearching:$isSearching,
                  didChangeSearchText: { self.viewModel.searchText = $0 },
                  didTapSearchItem: { self.viewModel.searchText = $0 }) {
                    /// Step3: 😎 Let's wrap SwiftUI Views in it using trailing closure.
                    self.navigationView
        }
    }
}

// MARK: - Views
extension ItemListView {
    var navigationView: some View {
        NavigationView {
            listView
                .navigationBarTitle("Spotlight")
                .navigationBarItems(trailing:
                    Button(action: {
                        //
                        print("search click!")
                        
                        self.isSearching.toggle()
                        
                    }) {
                        Image(systemName: "magnifyingglass")
                    }
                )
        }
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(title: Text(viewModel.errorMessage))
        }
    }

    var listView: some View {
        List(self.viewModel.searchedItems, id: \.id) { item in
            NavigationLink(destination: DetailView(item: item)) {
                ItemRow(item: item)
            }
        }
        .navigationBarTitle(Text("Photos"))
    }
}
