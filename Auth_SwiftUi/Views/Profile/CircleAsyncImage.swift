//
//  CircleAsyncImage.swift
//  Auth_SwiftUi
//
//  Created by Milad Khalighi on 2023-08-09.
//

import SwiftUI

struct CircleAsyncImage: View {
    var url : String = ""
    var body: some View {
        AsyncImage(url: URL(string: url),transaction: .init(animation: .easeInOut(duration: 0.8))) { phase in
            switch phase {
            case .success(let image) :
                image
                    .resizable()
                    .frame(width: 64,height: 64)
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(.primary.opacity(0.6))
                    .background(.gray.opacity(0.4))
                    .mask(Circle())
                    .backgroundAngularGradient()
                    .overlay {
                        Circle().stroke().foregroundLinearGradient()
                            .blendMode(.overlay)
                    }
            case .failure(_) :
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 64,height: 64)
                    .foregroundColor(.primary.opacity(0.6))
                    .background(.gray.opacity(0.4))
                    .mask(Circle())
                    .backgroundAngularGradient()
                    .overlay {
                        Circle().stroke().foregroundLinearGradient()
                            .blendMode(.overlay)
                    }
            case .empty :
//                ProgressView()
//                    .frame(width: 64,height: 64)
//                    .background(.gray.opacity(0.4))
//                    .mask(Circle())
//                    .backgroundAngularGradient()
//                    .overlay {
//                        Circle().stroke().foregroundLinearGradient()
//                            .blendMode(.overlay)
//                    }
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 64,height: 64)
                    .foregroundColor(.primary.opacity(0.6))
                    .background(.gray.opacity(0.4))
                    .mask(Circle())
                    .backgroundAngularGradient()
                    .overlay {
                        Circle().stroke().foregroundLinearGradient()
                            .blendMode(.overlay)
                    }
            @unknown default:
                ProgressView()
                    .frame(width: 64,height: 64)
                    .background(.gray.opacity(0.4))
                    .mask(Circle())
                    .backgroundAngularGradient()
                    .overlay {
                        Circle().stroke().foregroundLinearGradient()
                            .blendMode(.overlay)
                    }
            }
            
        }

    }
}

struct CircleAsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleAsyncImage()
    }
}
