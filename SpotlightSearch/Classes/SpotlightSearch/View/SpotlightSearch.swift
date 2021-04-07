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
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Binding var isSearching: Bool
    @ObservedObject var viewModel: SpotlightSearchViewModel
    
    var didSearchKeyword: (String) -> Void
    var didTapItem: (String) -> Void
    
    var configuration = SpotlightConfiguration()
    
    var content: () -> Content

    // MARK: - Initializers
    public init(
        viewModel: SpotlightSearchViewModel,
        isSearching: Binding<Bool>,
        configuration: SpotlightConfiguration = SpotlightConfiguration(),
        didSearchKeyword: @escaping (String) -> Void,
        didTapItem: @escaping (String) -> Void,
        wrapContentView: @escaping () -> Content) {
        
        self.content = wrapContentView
        
        self._isSearching = isSearching
        
        self.configuration = configuration
        self.didTapItem = didTapItem
        self.didSearchKeyword = didSearchKeyword
        
        switch self.configuration.colors {
            case .property(listItemTextColor: let listItemTextColor,
                           searchTextColor: let searchTextColor,
                           searchIconColor: let searchIconColor,
                           deleteIconColor: let deleteIconColor,
                           dismissIconColor: let dismissIconColor):
                self.listItemTextColor = listItemTextColor
                self.searchTextColor = searchTextColor
            
                self.searchIconColor = searchIconColor
                self.deleteIconColor = deleteIconColor
                self.dismissIconColor = dismissIconColor
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

        self.viewModel = viewModel
        self.viewModel.didSearchKeyword = didSearchKeyword
    }

    private let listItemTextColor: Color
    private let searchTextColor: Color
    
    private let placeHolderFont: Font
    private let placeholderText: String
    
    private let searchIconColor: Color
    private let deleteIconColor: Color
    private let dismissIconColor: Color
    
    private let searchIcon: Image
    private let deleteIcon: Image
    private let dismissIcon: Image
}

// MARK: - Body
extension SpotlightSearch {
    public var body: some View {
        return AnyView(
            GeometryReader { geometry in
                ZStack(alignment: .center) {
                    Rectangle()
                        .foregroundColor(colorScheme == .dark ? .black : .gray)
                        .opacity(isSearching ? 0.5 : 0.0)
                        .edgesIgnoringSafeArea([.all])
                        .frame(width: UIScreen.main.bounds.size.width,
                               height: UIScreen.main.bounds.size.height)
                        
                    content()
                        .disabled(false)
                        .blur(radius: isSearching ? 15.0 : 0)
                    
                    if isSearching {
                        searchBar
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
            dismissView

            ZStack {
                TextField(placeholderText,
                          text: $viewModel.searchingText,
                          onCommit: {
                            withAnimation(.easeIn(duration: 1.0)) {
                                isSearching = false
                            }
                    })
                    .textFieldStyle(DefaultTextFieldStyle())
                    .foregroundColor(searchTextColor)
                    .font(placeHolderFont)
                    .keyboardType(.default)
                    .modifier(ClearAllTextModifier(text: $viewModel.searchingText,
                                                   deleteIcon: deleteIcon,
                                                   deleteIconColor: deleteIconColor))
                    .padding([.leading], LEADING_PADDING + ICON_WIDTH + 30)
                    .shadow(color: Color.black, radius: 0.1, x: 0.1, y: 0.1)
                
                HStack {
                    searchIcon
                        .resizable()
                        .scaledToFit()
                        .frame(width: ICON_WIDTH + 10, height: ICON_WIDTH + 10)
                        .foregroundColor(searchIconColor)
                        .padding([.leading], LEADING_PADDING)
                        .shadow(color: Color.black, radius: 0.1, x: 0.1, y: 0.1)
                    
                    Spacer()
                }
            }
                 
            GeometryReader { geometry in
                ScrollView {
                    ForEach(viewModel.founds, id: \.self) { found in
                        Button(action: {
                            viewModel.searchingText = found
                            didTapItem(found)
                        }) {
                            HStack {
                                Text(found)
                                    .font(Font.system(size: 18, weight: .light, design: .rounded))
                                    .foregroundColor(listItemTextColor)
                                    .shadow(color: Color.black, radius: 0.1, x: 0.1, y: 0.1)
                                    .padding([.leading], LEADING_PADDING)
                                    .padding([.top, .bottom, .trailing])
                                    
                                Spacer()
                            }
                            .frame(width: geometry.size.width)
                        }
                    }.background(Color.clear)
                }
            }

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
                                .frame(width: 25.0, height: 25.0)
                                .foregroundColor(self.dismissIconColor)
                                .padding([.trailing], 25)
                                .padding([.top], 50)
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
        colors: SpotlightColor = .property(listItemTextColor: .blue,
                                           searchTextColor: .white,
                                           searchIconColor:.blue,
                                           deleteIconColor:.blue,
                                           dismissIconColor:.blue),
        
        icons: SpotlightIcon = .property(searchIcon: Image(systemName: "magnifyingglass"),
                                         deleteIcon: Image(systemName: "xmark.square.fill"),
                                         dismissIcon: Image(systemName: "xmark"))) {
        self.placeHolder = placeHolder
        self.colors = colors
        self.icons = icons
    }
}

public enum SpotlightPlaceHolder {
    case property(placeHolderFont: Font, placeholderText: String)
}

public enum SpotlightColor {
    case property(
        listItemTextColor: Color,
        searchTextColor: Color,
        searchIconColor:Color,
        deleteIconColor:Color,
        dismissIconColor:Color)
}

public enum SpotlightIcon {
    case property(
        searchIcon: Image,
        deleteIcon: Image,
        dismissIcon: Image
    )
}
#endif
