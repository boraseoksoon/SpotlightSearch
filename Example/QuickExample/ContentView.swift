//
//  ContentView.swift
//  QuickExample
//
//  Created by Seoksoon Jang on 2019/12/05.
//  Copyright © 2019 Seoksoon Jang. All rights reserved.
//

import SwiftUI

/// Step1: 😆 import `SpotlightSearch`!
import SpotlightSearch

struct ContentView: View {
    @State private var isSearching = false
    @ObservedObject var viewModel = TestViewModel()
    
    let conf = SpotlightConfiguration(placeHolder:.property(placeHolderFont: Font.system(size: 30,
                                                                                         weight: .light,
                                                                                         design: .rounded),
                                                            placeholderText: "Search Anything"),
                                      colors: .property(listItemTextColor: .blue,
                                                        searchTextColor: .white,
                                                        searchIconColor:.red,
                                                        deleteIconColor:.gray,
                                                        dismissIconColor:.red),
                                      icons: .property(
                                        searchIcon:Image(systemName: "magnifyingglass"),
                                        deleteIcon: Image(systemName: "xmark.circle.fill"),
                                        dismissIcon:Image(systemName: "x.circle")
        )
    )

    // MARK: - Body
    var body: some View {
        /// Step2: 😆 Declare `Spotlight` externally.
        SpotlightSearch(searchKeywords:viewModel.searchableItems,
                  isSearching:$isSearching,
                  configuration: conf, 
                  didChangeSearchText: { self.viewModel.searchText = $0 },
                  didTapSearchItem: { self.viewModel.searchText = $0 }) {
                    /// Step3: 😎 Let's wrap SwiftUI Views in it using trailing closure.
                    Button(action: {
                        withAnimation(.easeIn(duration: 0.3)) {
                            self.isSearching.toggle()
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
        }
    }
}

class TestViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchableItems: [String] = ["Objective-C",
                                                "Clojure",
                                                "Swift",
                                                "Javascript",
                                                "Python",
                                                "Haskell",
                                                "Scala",
                                                "Rust",
                                                "C",
                                                "C++",
                                                "Dart",
                                                "C#",
                                                "F#",
                                                "LISP",
                                                "Golang",
                                                "Kotlin",
                                                "Java",
                                                "Assembly",
                                                "안녕하세요",
                                                "감사합니다",
                                                "사랑합니다",
                                                "행복하세요"]
}
