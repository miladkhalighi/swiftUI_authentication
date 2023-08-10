//
//  AngularButton.swift
//  Auth_SwiftUi
//
//  Created by Milad Khalighi on 2023-07-31.
//

import SwiftUI

struct AngularButton: View {
    
    var title : String
    var action : () -> Void
    //@State var angel : Double = 0
    @State var appear = false
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .fontWeight(.bold)
                .foregroundLinearGradient()
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 48)
                .background(
                    Color("tertiaryBackground").opacity(0.8) , in: RoundedRectangle(cornerRadius: 16,style: .continuous)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16,style: .continuous).stroke(.white.opacity(0.4))
                )
        }
        .onAppear{
            withAnimation(.linear(duration: 7).repeatForever(autoreverses: true)) {
                appear = true
            }
        }
        .backgroundAngularGradient(radius: 16,degree: appear ? 350 : 0)
        }

    }

struct AngularButton_Previews: PreviewProvider {
    static var previews: some View {
        AngularButton(title: "Sign in", action: {})
    }
}
