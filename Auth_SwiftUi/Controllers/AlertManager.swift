//
//  AlertDialog.swift
//  Auth_SwiftUi
//
//  Created by Milad Khalighi on 2023-08-02.
//

import Foundation


class AlertManager : ObservableObject {
    @Published var showAlert = false
    @Published var alert = AlertModel(title: "", message: "")
}
