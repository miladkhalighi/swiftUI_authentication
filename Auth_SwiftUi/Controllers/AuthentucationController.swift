//
//  AuthentucationController.swift
//  Auth_SwiftUi
//
//  Created by Milad Khalighi on 2023-07-29.
//

import Foundation
import FirebaseAuth


class AuthenticationController : ObservableObject, SignInWithAppleDelegate {
    
   @Published var showSignInCard = false
   @Published var exitAuthPage = false
    
    init() {
        // Initialize SignInWithAppleObject and set its delegate to self
        let signInWithAppleObject = SignInWithAppleObject()
        signInWithAppleObject.delegate = self
    }
    func didSignInWithApple() {
        exitAuthPage.toggle()
    }
    
    
    func isValidEmail(_ email: String) -> String? {
        if (email.isEmpty){
            return "email address can not be empty"
        }
        // Regular expression pattern for email validation
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        if(!emailPredicate.evaluate(with: email)){
            return "enter valid email address"
        }
        else{
            return nil
        }
    }
    
    func isValidPassword(_ password : String) -> String? {
        if(password.isEmpty){
            return "password can not be empty"
        }
        if(password.count < 8 ){
            return "password must be at least 8 chars"
        }
        else{
            return nil
        }
    }
}
