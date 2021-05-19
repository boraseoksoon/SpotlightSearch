//
//  ContentView.swift
//  QuickExample
//
//  Created by Seoksoon Jang on 2019/12/05.
//  Copyright © 2019 Seoksoon Jang. All rights reserved.
//

/// Step1: 😆 import `SpotlightSearch`!
import SpotlightSearch
import SwiftUI

struct ContentView: View {
    // This is "View Model" for Spotlight Search exclusively.
    @ObservedObject var spotlightViewModel = SpotlightSearchViewModel(initialDataSource:["Swift", "Clojure"])
    @State private var isSearching = false
    
    // This is your View Model Example.
    // It should be independent of SpotlightSearchViewModel.
    // It should never be related to SpotlightSearchViewModel.
    // Totally separate one.
    @ObservedObject var viewModel = LocalViewModel(helloText: "")
    

    // MARK: - Body
    
    var body: some View {
        SpotlightSearch(
            viewModel: spotlightViewModel,
            isSearching:$isSearching,
            didSearchKeyword: search,
            didTapItem: { print("didTapItem : \($0)") }) {
                /// 😎 your main UI goes here.
                Text("Your all main views goes here")
            }
    }
}

// MARK: - Variables
extension ContentView {
    var yourMainView: some View {
        VStack {
            TextField("say something", text: $viewModel.helloText)
                .padding(100)
            
            Button(action: {
                withAnimation(.easeIn(duration: 0.3)) {
                    isSearching.toggle()
                }
            }) {
                
                ZStack {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80.0, height: 80.0)
                        .foregroundColor(.blue)
                }
            }
            
            Spacer()
        }
        
    }
}

// MARK: - Private Methods
extension ContentView {
    private func search(searchKeyword: String) {
        DispatchQueue.global().async {
            // Assuming you did finish your logic to fetch new data from anywhere.
            let res = generateRandomString(upto:500, isDuplicateAllowed: true)
            
            
            // after that, update data source.
            DispatchQueue.main.async {
                // To update data source of SpotlightSearch,
                // if not used, initialDataSource is used for your data source
                spotlightViewModel.update(dataSource:res)
            }
        }
    }
}

class LocalViewModel: ObservableObject {
    @Published var helloText: String
    
    init(helloText: String) {
        self.helloText = helloText
    }
}

