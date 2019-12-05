//
//  ClearAllTextModifier.swift
//  SwiftUIExample
//
//  Created by Seoksoon Jang on 2019/12/04.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import SwiftUI

struct ClearAllTextModifier: ViewModifier {
    @Binding var text: String
    
    public func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            content
            
            if !text.isEmpty {
                Button(action: {
                    self.text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: BUTTON_WIDTH, height: BUTTON_WIDTH)
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 15)
            }
        }
    }
}
