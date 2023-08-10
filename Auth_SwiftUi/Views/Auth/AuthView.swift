//
//  AuthView.swift
//  Auth_SwiftUi
//
//  Created by Milad Khalighi on 2023-07-28.
//

import SwiftUI
import FirebaseAuth

struct AuthView: View {
    
    @EnvironmentObject var authController : AuthenticationController
    @EnvironmentObject var alertManager : AlertManager
    @State var scrollY : CGFloat = 0
    

    var body: some View {
            ScrollView{
                GeometryReader { reader in
                    let minY = reader.frame(in: .named("scroll")).minY
                    Color.clear.preference(key: scrollPref.self, value: minY)
                }
                Group{
                    if(authController.showSignInCard){
                        SignupCard()
                    }
                    else{
                        SigninCard()
                    }
                }
                    //.hueRotation(.degrees(scrollY/4))
                    .rotation3DEffect(.degrees(scrollY/10), axis: (x: 10, y: 5, z: 1))
                    .shadow(color: Color("shadowColor"), radius: 30, y: 30)
                .padding(.top, 100)

            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(scrollPref.self, perform: { value in
                    scrollY = value
            })
            .background(
                Image(authController.showSignInCard ? "background-3" : "background-1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .scaleEffect(1 + abs(scrollY/1000))
                    .ignoresSafeArea()
            )
            .onAppear{
                Auth.auth().addStateDidChangeListener { auth, user in
                    if(user != nil){
                        authController.exitAuthPage = true
                    }
                }
            }
            .fullScreenCover(isPresented: $authController.exitAuthPage) {
                ProfileView()
            }


    }
    
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
            .environmentObject(AuthenticationController())
            .environmentObject(AlertManager())
            .preferredColorScheme(.dark)
    }
}
