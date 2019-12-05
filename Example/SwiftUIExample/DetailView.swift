//
//  DetailView.swift
//  SwiftUIExample
//
//  Created by Seoksoon Jang on 2019/12/05.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import SwiftUI

struct DetailView: View {
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
        Image(uiImage: imageLoader.image ?? UIImage(systemName: "xmark") ?? UIImage())
            .scaledToFit()
            .frame(width: UIScreen.main.bounds.size.width,
                   height: UIScreen.main.bounds.size.height,
                   alignment: .center)
    }
}
