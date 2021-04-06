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
    @ObservedObject var viewModel = TestViewModel()
    @State private var isSearching = false
    
    // MARK: - Body
    
    /// Step2: 😆 Declare `SpotlightSearch` externally.
    var body: some View {
        SpotlightSearch(searchKeywords:viewModel.keywords,
                        isSearching:$isSearching,
                        didTapItem: {
                            print("didTapItem : \($0)")
                        }) {
            /// Step3: 😎 your UI goes here.
            yourMainView
        }
    }
}

// MARK: - Variables
extension ContentView {
    var yourMainView: some View {
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
    }
}

class TestViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var keywords: [String] = ["Objective-C",
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
