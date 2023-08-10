//
//  SigninView.swift
//  Auth_SwiftUi
//
//  Created by Milad Khalighi on 2023-07-28.
//

import SwiftUI
import FirebaseAuth

struct SigninCard: View {
    
    @State var email = ""
    @State var password = ""
    
    @State var selectedEmail = false
    @State var selectedPass = false
    
    @State var animEmail = false
    @State var animPass = false
    
    @State var appear = [false,false,false,false]
    
    @EnvironmentObject var authController : AuthenticationController
    @EnvironmentObject var alert : AlertManager
    @State private var signInWithAppleObject = SignInWithAppleObject()
    
    var body : some View {
        content
        .alert(alert.alert.title, isPresented: $alert.showAlert) {
            Button("Got it!") {
                //
            }
        } message: {
            Text(alert.alert.message)
        }
        .scaleEffect(appear[0] ? 1 : 0.5)

    }
    
    
    var content : some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Sign in")
                .font(.largeTitle.weight(.bold))
                .foregroundColor(.white)
            Text("Access to 120+ hours of courses, tutorials and livestreams")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.6))
            emailField
            passwordField
            signinBtn
            
            Button {
                toggleCard()
            } label: {
                HStack {
                    Text("Don’t have an account?")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.6))
                    Text("Sign up")
                        .font(.footnote.weight(.bold))
                        .foregroundLinearGradient()
                }
            }
            .opacity(appear[2] ? 1 : 0)
            Button {
                resetPassword()
            } label: {
                HStack {
                    Text("Forgot password?")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.6))
                    Text("Reset Password")
                        .font(.footnote.weight(.bold))
                        .foregroundLinearGradient()
                }
            }
            .opacity(appear[2] ? 1 : 0)
            Divider().background(.white.opacity(0.9))
            Button {
                signInWithAppleObject.signInWithApple()
            } label: {
                SignInWithAppleButton()
                    .frame(height: 48)
            }
            .scaleEffect(x: appear[3] ? 1.0 : 1.2)
            .opacity(appear[3] ? 1 : 0)
            .onAppear{
                withAnimation(.easeInOut.delay(0.6)) {
                    appear[3] = true
                }
            }

        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous).stroke(.white.opacity(0.5))
                .background(.ultraThinMaterial)
                .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                //.shadow(color: Color("shadowColor"), radius: 30, y: 30)
        )
        .padding(.horizontal,20)
    }
    
    var emailField : some View {
        HStack(spacing: 12){
            AngularIcon(icon: "envelope.open.fill", selected: $selectedEmail)
                .scaleEffect(animEmail ? 1.2 : 1.0)
            TextField("Email Address", text: $email)
                .foregroundColor(.white)
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.none)
        }
        .padding(.horizontal,8)
        .frame(height: 56)
        .background(Color("secondaryBackground").opacity(0.8), in: RoundedRectangle(cornerRadius: 16,style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16,style: .continuous).stroke(.white.opacity(0.4))
        )
        .onTapGesture{fieldOntapAnimation(isEmail: true)}
        .scaleEffect(x: appear[0] ? 1.0 : 1.2)
        .opacity(appear[0] ? 1 : 0)
        .onAppear{
            withAnimation(.easeInOut) {
                appear[0] = true
            }
        }
    }
    
    var passwordField : some View {
        HStack(spacing: 12){
            AngularIcon(icon: "key.fill", selected: $selectedPass)
                .scaleEffect(animPass ? 1.2 : 1.0)
            SecureField("Password", text: $password)
                .foregroundColor(.white)
                .textContentType(.password)
        }
        .padding(.horizontal,8)
        .frame(height: 56)
        .background(Color("secondaryBackground").opacity(0.8), in: RoundedRectangle(cornerRadius: 16,style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16,style: .continuous).stroke(.white.opacity(0.4))
        )
        .onTapGesture {fieldOntapAnimation(isEmail: false)}
        .scaleEffect(x: appear[1] ? 1.0 : 1.2)
        .opacity(appear[1] ? 1 : 0)
        .onAppear{
            withAnimation(.easeInOut.delay(0.2)) {
                appear[1] = true
            }
        }
    }
    
    var signinBtn : some View {
        AngularButton(title: "Sign in") {
            signin()
        }
        .scaleEffect(x: appear[2] ? 1.0 : 1.2)
        .opacity(appear[2] ? 1 : 0)
        .onAppear{
            withAnimation(.easeInOut.delay(0.4)) {
                appear[2] = true
            }
        }
    }
    
    
    func signin(){
      
        if let validEmailMsg = authController.isValidEmail(email) {
            alert.alert.title = validEmailMsg
            alert.alert.message = ""
            alert.showAlert.toggle()
        }
        else{
            if let validPassMsg = authController.isValidPassword(password) {
                alert.alert.title = validPassMsg
                alert.alert.message = ""
                alert.showAlert.toggle()
            }
            else{
                Auth.auth().signIn(withEmail: email, password: password) { result, error in
                    if let error = error {
                        print(error.localizedDescription)
                        alert.alert.title = "User sign in failure"
                        alert.alert.message = error.localizedDescription
                        alert.showAlert.toggle()
                    }
                    else{
                        if let result = result {
                            print(result.description)
                            print("user signed in")
                            authController.exitAuthPage = true
                        }
                    }
                }
            }
        }
 
    }
    
    func resetPassword(){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                alert.alert.title = "Something is wrong!"
                alert.alert.message = error.localizedDescription
                alert.showAlert.toggle()
            }
            else{
                alert.alert.title = "Check your email"
                alert.alert.message = "reset password's link sent to your email address"
                alert.showAlert.toggle()
                
            }
        }
        
    }
    
    func toggleCard(){
        withAnimation(.spring()) {
            authController.showSignInCard.toggle()
        }
    }
    
    func fieldOntapAnimation(isEmail : Bool){
        if !isEmail{
            withAnimation(.easeInOut) {
                selectedEmail = false
                selectedPass = true
            }
            withAnimation {
                animPass = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25 ){
                withAnimation {
                    animPass = false
                }
            }
        }
        else{
            withAnimation(.easeInOut) {
                selectedEmail = true
                selectedPass = false
            }
            withAnimation {
                animEmail = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25 ){
                withAnimation {
                    animEmail = false
                }
            }
        }

    }

    
}

struct SigninView_Previews: PreviewProvider {
    static var previews: some View {
        SigninCard()
            .environmentObject(AuthenticationController())
            .environmentObject(AlertManager())
            .preferredColorScheme(.dark)
            .background(Image("background-1"))
        
    }
}
