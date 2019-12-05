//
//  SpotlightSearch.swift
//  SwiftUIExample
//
//  Created by Seoksoon Jang on 2019/12/04.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import SwiftUI

public struct SpotlightSearch<Content>: View where Content: View {
    // MARK: - SwiftUI Instance Variables
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject var spotlightSearchVM: SpotlightSearchVM
    @Binding var isSearching: Bool

    // MARK: - Instance Variables
    
    // MARK: - Closures
    var didChangeSearchText: (String) -> Void
    var didTapSearchItem: (String) -> Void
    var content: () -> Content
    
    // MARK: - Initializers
    public init(searchKeywords: [String],
         isSearching: Binding<Bool>,
         didChangeSearchText: @escaping (String) -> Void,
         didTapSearchItem: @escaping (String) -> Void,
         wrappingClosure: @escaping () -> Content) {
        
        /// FIXME: THOSE GLOBAL THINGS MAY BE APPLIED TO ALL APP ALTHOUGH MODULE IS SEPARATED.
        /// BUT, THERE IS NO SUCH THING AS API BY WHICH I CAN MODIFY SWIFTUI.
        UITableView.appearance().allowsSelection = false
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().contentInset = UIEdgeInsets(top:0,
                                                             left: 0,
                                                             bottom: 300,
                                                             right: 0)
        
        UITableViewCell.appearance().selectionStyle = .none
        UITableViewCell.appearance().backgroundColor = .clear
        
        self.content = wrappingClosure
        self._isSearching = isSearching
        
        self.didTapSearchItem = didTapSearchItem
        self.didChangeSearchText = didChangeSearchText
        
        self.spotlightSearchVM = SpotlightSearchVM(searchKeywords: searchKeywords,
                                                   didChangeSearchText: didChangeSearchText)
    }

    // MARK: - Body
    public var body: some View {
        return AnyView(
            GeometryReader { geometry in
                ZStack(alignment: .center) {
                    self.content()
                        .disabled(false)
                        .blur(radius: self.isSearching ? 15.0 : 0)

                    if self.isSearching {
                        self.searchBar
                    }
                }
                
            }
        )
    }
}

// MARK: - Views 
extension SpotlightSearch {
    var searchBar: some View {
        VStack {
            self.dismissView

            ZStack {
                TextField("Search Anything",
                          text: self.$spotlightSearchVM.searchingText,
                          onCommit: {
                            withAnimation(.easeIn(duration: 1.0)) {
                                self.isSearching = false
                            }
                    })
                    .textFieldStyle(DefaultTextFieldStyle())
                    .foregroundColor(colorScheme == .dark ? .white : .gray)
                    .font(Font.system(size: 30, weight: .light, design: .rounded))
                    .keyboardType(.default)
                    .modifier(ClearAllTextModifier(text: self.$spotlightSearchVM.searchingText))
                    .padding([.leading], LEADING_PADDING + ICON_WIDTH + 30)
                    .padding([.trailing], LEADING_PADDING)
                    .shadow(color: Color.black, radius: 0.1, x: 0.1, y: 0.1)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: ICON_WIDTH + 10, height: ICON_WIDTH + 10)
                        .foregroundColor(.blue)
                        .padding([.leading], LEADING_PADDING)
                    
                    Spacer()
                }
            }
                        
            List(self.spotlightSearchVM.founds, id: \.self) { found in
                Button(action: {
                    self.didTapSearchItem(found)
                    self.spotlightSearchVM.searchingText = found
                }) {
                    Text(found)
                        .foregroundColor(self.colorScheme == .dark ? .white : .gray)
                        .font(Font.system(size: 18, weight: .light, design: .rounded))
                        .shadow(color: Color.black, radius: 0.1, x: 0.1, y: 0.1)
                }
            }
            .colorMultiply(Color.blue)
            
        }
    }
    
    var dismissView: some View {
        return (
            VStack {
                HStack {
                    Spacer()

                    Button(action: {
                        withAnimation(.easeIn(duration: 0.3)) {
                            self.isSearching = false
                        }
                        
                    }) {
                        ZStack {
                            Image(systemName: "x.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30.0, height: 30.0)
                                .foregroundColor(.blue)
                                .padding([.top, .trailing], 25)
                        }

                    }
                }
            }
            .padding([.bottom], BOTTOM_PADDING * 2.5)
        )
    }
}
