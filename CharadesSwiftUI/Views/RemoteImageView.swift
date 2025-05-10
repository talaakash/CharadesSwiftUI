//
//  RemoteImageView.swift
//  CharadesSwiftUI
//
//  Created by Admin on 09/05/25.
//


import SwiftUI
import Kingfisher

struct RemoteImageView: View {
    let imageUrl: URL

    var body: some View {
        KFImage(imageUrl)
            .placeholder {
                ProgressView()
            }
            .cancelOnDisappear(true)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
