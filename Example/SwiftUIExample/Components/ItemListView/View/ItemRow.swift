//
//  ItemRow.swift
//  Spotlight
//
//  Created by boraseoksoon on 11/18/2019.
//  Copyright (c) 2019 boraseoksoon. All rights reserved.
//

import SwiftUI
import Combine

struct ItemRow: View {
    var item: Photo
    @ObservedObject var imageLoader: ImageLoader
    
    init(item: Photo) {
        self.item = item

        self.imageLoader = ImageLoader(
            loadable: URL(string: item.imageURL ?? "") ?? UIImage(systemName: "xmark") ?? UIImage(),
            id: item.id
        )
    }
    
    var body: some View {
        VStack {
            itemRow
        }
    }
}

// MARK: - Views
extension ItemRow {
    var itemRow: some View {
        HStack {
            Image(uiImage: imageLoader.image ?? UIImage(systemName: "xmark") ?? UIImage())
                .resizable()
                .clipShape(Circle())
                .frame(width: 180.0,
                       height: 180.0,
                       alignment: .center)
                .scaledToFit()
                .overlay(Circle().stroke(Color.white,lineWidth:2).shadow(radius: 10))
            
            VStack(alignment: .leading) {
                Text("Author: \(item.name ?? "unknown author")")
                    .font(Font.system(size: 16, weight: .regular, design: .default))
                    .foregroundColor(.blue)
                    .padding([.bottom], 10)
                    .lineLimit(3)
                
                Text("Size: \(item.description ?? "")")
                    .font(Font.system(size: 14, weight: .light, design: .default))
                    .foregroundColor(.gray)
                    .lineLimit(3)
            }
            .padding([.leading], 5)
        }
        .padding([.top, .bottom], 20)
    }
}
