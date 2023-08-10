//
//  Extentions.swift
//  Auth_SwiftUi
//
//  Created by Milad Khalighi on 2023-07-27.
//

import SwiftUI

extension View {
    func foregroundLinearGradient() -> some View {
        self
            .foregroundStyle(LinearGradient(colors: [Color("pink-gradient-1"),Color("pink-gradient-2")], startPoint: .topLeading, endPoint: .bottomTrailing))
    }
    
    func backgroundAngularGradient(radius : CGFloat=16, degree: Double=0) -> some View {
        self
            .background(
            RoundedRectangle(cornerRadius: radius, style: .continuous).fill(AngularGradient(colors: [
                Color(#colorLiteral(red: 0.3843137255, green: 0.5176470588, blue: 1, alpha: 1)),Color(#colorLiteral(red: 1, green: 0.4470588235, blue: 0.7137254902, alpha: 1)),Color(#colorLiteral(red: 0.8509803922, green: 0.6862745098, blue: 0.8509803922, alpha: 1)),Color(#colorLiteral(red: 0.5921568627, green: 0.8823529412, blue: 0.831372549, alpha: 1)),
            ], center: .center, angle: .degrees(degree)))
                .blur(radius: 10)
        )
    }
}
