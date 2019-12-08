//
//  Configuration.swift
//  Pods-QuickExample
//
//  Created by Seoksoon Jang on 2019/12/09.
//

import Foundation
import SwiftUI

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

//let conf = SpotlightConfiguration(placeHolder:.property(placeHolderFont: Font.footnote,
//                                                        placeholderText: "Search Anything"),
//                                  colors: .property(listItemTextColor:.white, searchTextColor:.white),
//                                  icons: .property(
//                                    searchIcon:Image(systemName: "magnifyingglass"),
//                                    deleteIcon: Image(systemName: "xmark.circle.fill"),
//                                    dismissIcon:Image(systemName: "x.circle")
//    )
//)
