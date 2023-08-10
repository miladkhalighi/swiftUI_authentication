//
//  SignInWithAppleButton.swift
//  Advanced SwiftUI
//
//  Created by Sai Kambampati on 4/6/21.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth

struct SignInWithAppleButton: UIViewRepresentable {
    @Environment(\.colorScheme) var scheme
    typealias UIViewType = ASAuthorizationAppleIDButton
    func makeUIView(context: Context) -> UIViewType {
        return ASAuthorizationAppleIDButton(type: .signIn, style: scheme==ColorScheme.dark ? .white : .black)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}


