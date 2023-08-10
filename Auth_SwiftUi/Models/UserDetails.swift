//
//  User.swift
//  Auth_SwiftUi
//
//  Created by Milad Khalighi on 2023-08-03.
//

import Foundation
import FirebaseFirestore

struct UserDetails: Identifiable,Codable {
    var id: String
    var name: String?
    var email: String?
    var website: String?
    var bio: String?
    var description: String?
    var photoUrl: String?
    var proMember: Bool?
    var userSince: Date?
     
}

extension UserDetails {
    // Convert Timestamp to Date
    static func date(fromTimestamp timestamp: Timestamp) -> Date {
        return timestamp.dateValue()
    }
    
    // Convert Date to Timestamp
    static func timestamp(fromDate date: Date) -> Timestamp {
        return Timestamp(date: date)
    }
}

