//
//  FirestoreManager.swift
//  Auth_SwiftUi
//
//  Created by Milad Khalighi on 2023-08-03.
//

import Foundation
import Firebase

class FirestoreManager : ObservableObject {
    @Published var user : UserDetails?
    
    
    func saveUser(_ user: UserDetails, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let userRef = db.collection("Users").document(user.id)
        
        do {
            let data = try JSONEncoder().encode(user)
            if let userDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                userRef.setData(userDict) { error in
                    if let error = error {
                        completion(error) // Pass the error to the completion handler
                    } else {
                        completion(nil) // Pass nil if there's no error
                    }
                }
            }
        } catch {
            completion(error) // Pass the error to the completion handler if there's an encoding error
        }
    }
    
    func getUserDetails(with userID: String, completion: @escaping (UserDetails?, Error?) -> Void) {
        let db = Firestore.firestore()
        let userRef = db.collection("Users").document(userID)
        
        userRef.getDocument { snapshot, error in
            if let error = error {
                completion(nil, error)
            } else {
                if let data = snapshot?.data() {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: data)
                        var user = try JSONDecoder().decode(UserDetails.self, from: jsonData)
                        // Parse userSince timestamp to Date
                        if let userSinceTimestamp = data["userSince"] as? Timestamp {
                            user.userSince = userSinceTimestamp.dateValue()
                        }
                        
                        completion(user, nil)
                    } catch {
                        completion(nil, error)
                    }
                } else {
                    completion(nil, nil) // If user doesn't exist or data cannot be decoded, return nil for user and error.
                }
            }
        }
    }
    
    
}
