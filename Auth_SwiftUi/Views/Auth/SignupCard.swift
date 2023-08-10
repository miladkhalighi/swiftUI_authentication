//
//  SignUp.swift
//  Auth_SwiftUi
//
//  Created by Milad Khalighi on 2023-07-28.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignupCard: View {
    
    @State var email = ""
    @State var password = ""
    @State var selectedEmail = false
    @State var selectedPass = false
    
    @State var animEmail = false
    @State var animPass = false
    
    @State var appear = [false,false,false]
    
    
    @EnvironmentObject var authController : AuthenticationController
    @EnvironmentObject var alertController : AlertManager
    @EnvironmentObject var firestoreManager : FirestoreManager

    var body: some View {
        content
            .alert(alertController.alert.title, isPresented: $alertController.showAlert) {
                Button("Got it!") {
                    //
                }
            } message: {
                Text(alertController.alert.message)
            }
            .scaleEffect(appear[0] ? 1 : 0.5)
    }
    
    var content : some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Sign up")
                .font(.largeTitle.weight(.bold))
                .foregroundColor(.white)
            Text("Access to 120+ hours of courses, tutorials and livestreams")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.6))
            emailField
            passwordField
            
            AngularButton(title: "Create account") {
                createAccount()
            }
            .scaleEffect(x: appear[2] ? 1.0 : 1.2)
            .opacity(appear[2] ? 1 : 0)
            .onAppear{
                withAnimation(.easeInOut.delay(0.4)) {
                    appear[2] = true
                }
            }

            Text("By clicking on Sign up, you agree to our Terms of service and Privacy policy.")
                .font(.footnote)
                .foregroundColor(.white.opacity(0.6))
            Divider().background(.white.opacity(0.9))
            Button {
                toggleCard()
            } label: {
                HStack {
                    Text("Already have an account?")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.6))
                    Text("Sign in")
                        .font(.footnote.weight(.bold))
                        .foregroundLinearGradient()
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
        .onTapGesture {
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
        .onTapGesture {
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
        .scaleEffect(x: appear[1] ? 1.0 : 1.2)
        .opacity(appear[1] ? 1 : 0)
        .onAppear{
            withAnimation(.easeInOut.delay(0.2)) {
                appear[1] = true
            }
        }
    }
    
    func createAccount(){
        
        if let emailErr = authController.isValidEmail(email){
            alertController.alert.title = emailErr
            alertController.alert.message = ""
            alertController.showAlert.toggle()
        }
        else{
            if let passErr = authController.isValidPassword(password){
                alertController.alert.title = passErr
                alertController.alert.message = ""
                alertController.showAlert.toggle()
            }
            else{
                Auth.auth().createUser(withEmail: email, password: password){ result, error in
                    if let error = error {
                        alertController.alert.title = "Something is wrong!"
                        alertController.alert.message = error.localizedDescription
                        alertController.showAlert.toggle()
                    }
                    else{
                        if let result = result {
                            print(result.description)
                            authController.exitAuthPage = true
                            
                            //create user storage to put date
                            let user = UserDetails(id: result.user.uid,userSince: Date.now)
                            firestoreManager.saveUser(user) { err in
                                //
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func toggleCard(){
        withAnimation(.spring()) {
            authController.showSignInCard.toggle()
        }
    }
}

struct SignUp_Previews: PreviewProvider {

    static var previews: some View {
        SignupCard()
            .environmentObject(AuthenticationController())
            .environmentObject(AlertManager())
            .environmentObject(FirestoreManager())
            .preferredColorScheme(.dark)
            .background(Image("background-3"))
    }
}
