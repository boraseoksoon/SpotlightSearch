//
//  SpotlightSearch.swift
//  SwiftUIExample
//
//  Created by Seoksoon Jang on 2019/12/04.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

#if os(iOS)

import SwiftUI

public struct SpotlightSearch<Content>: View where Content: View {
    // MARK: - SwiftUI Instance Variables
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject var spotlightSearchVM: SpotlightSearchVM
    @Binding var isSearching: Bool

    // MARK: - Instance Variables
    var configuration = SpotlightConfiguration()
    
    let listItemTextColor: Color
    let searchTextColor: Color
    
    let placeHolderFont: Font
    let placeholderText: String
    let searchIcon: Image
    let deleteIcon: Image
    let dismissIcon: Image
    
    // MARK: - Closures
    var didChangeSearchText: (String) -> Void
    var didTapSearchItem: (String) -> Void
    var content: () -> Content
    
    // MARK: - Initializers
    public init(searchKeywords: [String],
         isSearching: Binding<Bool>,
         configuration: SpotlightConfiguration = SpotlightConfiguration(),
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
        
        self.configuration = configuration
        

        switch self.configuration.colors {
            case .property(listItemTextColor: let listItemTextColor,
                           searchTextColor: let searchTextColor):
                self.listItemTextColor = listItemTextColor
                self.searchTextColor = searchTextColor
        }
        
        switch self.configuration.placeHolder {
            case .property(placeHolderFont: let placeHolderFont,
                           placeholderText: let placeholderText):
                self.placeHolderFont = placeHolderFont
                self.placeholderText = placeholderText
        }
        
        switch self.configuration.icons {
            case .property(searchIcon: let searchIcon,
                           deleteIcon: let deleteIcon,
                           dismissIcon: let dismissIcon):
                self.searchIcon = searchIcon
                self.deleteIcon = deleteIcon
                self.dismissIcon = dismissIcon
        }

        self.didTapSearchItem = didTapSearchItem
        self.didChangeSearchText = didChangeSearchText
        
        self.spotlightSearchVM = SpotlightSearchVM(searchKeywords: searchKeywords,
                                                   didChangeSearchText: didChangeSearchText)
    }
}

// MARK: - Body
extension SpotlightSearch {
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
                TextField(self.placeholderText,
                          text: self.$spotlightSearchVM.searchingText,
                          onCommit: {
                            withAnimation(.easeIn(duration: 1.0)) {
                                self.isSearching = false
                            }
                    })
                    .textFieldStyle(DefaultTextFieldStyle())
                    .foregroundColor(self.searchTextColor)
                    .font(self.placeHolderFont)
                    .keyboardType(.default)
                    .modifier(ClearAllTextModifier(text: self.$spotlightSearchVM.searchingText,
                                                   deleteIcon: self.deleteIcon))
                    .padding([.leading], LEADING_PADDING + ICON_WIDTH + 30)
                    .shadow(color: Color.black, radius: 0.1, x: 0.1, y: 0.1)
                
                HStack {
                    self.searchIcon
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
                        .font(Font.system(size: 18, weight: .light, design: .rounded))
                        .shadow(color: Color.black, radius: 0.1, x: 0.1, y: 0.1)
                }
            }
            .colorMultiply(self.listItemTextColor)
            
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
                            self.dismissIcon
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

///
public struct SpotlightConfiguration {
    var placeHolder: SpotlightPlaceHolder
    var colors: SpotlightColor
    var icons: SpotlightIcon
    
    public init(
        placeHolder: SpotlightPlaceHolder = .property(placeHolderFont: Font.system(size: 30,
                                                                                   weight: .light,
                                                                                   design: .rounded),
                                                      placeholderText: "Search Anything"),
        colors: SpotlightColor = .property(listItemTextColor: .blue, searchTextColor: .white),
        icons: SpotlightIcon = .property(searchIcon: Image(systemName: "magnifyingglass"),
                                         deleteIcon: Image(systemName: "xmark.circle.fill"),
                                         dismissIcon: Image(systemName: "x.circle"))) {
        self.placeHolder = placeHolder
        self.colors = colors
        self.icons = icons
    }
}

public enum SpotlightPlaceHolder {
    case property(placeHolderFont: Font, placeholderText: String)
}

public enum SpotlightColor {
    case property(listItemTextColor: Color, searchTextColor: Color)
}

public enum SpotlightIcon {
    case property(
        searchIcon: Image,
        deleteIcon: Image,
        dismissIcon: Image
    )
}

#endif
