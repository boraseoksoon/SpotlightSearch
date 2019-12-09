//
//  ClearAllTextModifier.swift
//  SwiftUIExample
//
//  Created by Seoksoon Jang on 2019/12/04.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

#if os(iOS)
import SwiftUI

struct ClearAllTextModifier: ViewModifier {
    @Binding var text: String
    var deleteIcon: Image
    var deleteIconColor: Color
    
    public func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            content
                .padding([.trailing], 75)
            
            if !text.isEmpty {
                Button(action: {
                    self.text = ""
                }) {
                    deleteIcon
                        .resizable()
                        .scaledToFit()
                        .frame(width: BUTTON_WIDTH,
                               height: BUTTON_WIDTH)
                        .foregroundColor(deleteIconColor)
                }
                .padding(.trailing, LEADING_PADDING)
            }
        }
    }
}
#endif
