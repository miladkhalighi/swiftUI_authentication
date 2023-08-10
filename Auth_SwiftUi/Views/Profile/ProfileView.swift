//
//  ProfileView.swift
//  Auth_SwiftUi
//
//  Created by Milad Khalighi on 2023-07-27.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var alert : AlertManager
    @EnvironmentObject var firestoreManager : FirestoreManager
    
    @State var showSetting = false
    
    var body: some View {
        ZStack {
            
            Image("background-2")
                .resizable()
                .ignoresSafeArea()
            userCard
            
        .padding(20)
        }
        .alert(alert.alert.title, isPresented: $alert.showAlert) {
            Button("Got it!") {
                //
            }
        } message: {
            Text(alert.alert.message)
        }
        .sheet(isPresented: $showSetting) {
            SettingView()
        }
        .onAppear{
            fetchUser()
        }
    }
    
    var userCard : some View {
        VStack(alignment:.leading) {
            HStack(spacing: 16){
                CircleAsyncImage(url: firestoreManager.user?.photoUrl ?? "")
                    
                VStack(alignment: .leading,spacing: 4){
                    Text(firestoreManager.user?.name ?? "User Name")
                        .font(.title.bold())
                        .foregroundColor(.primary.opacity(0.8))
                        .lineLimit(1)
                    Text(Auth.auth().currentUser?.email ?? firestoreManager.user?.email ?? "user email")
                        .font(.footnote)
                        .foregroundColor(.primary.opacity(0.8))
                }
                Spacer()
                Button {
                    showSetting.toggle()
                } label: {
                    AngularIcon(icon: "gearshape.fill", selected: .constant(true))
                }

            }
            Divider().padding(10)
            HStack {
                Text("Member Since: ")
                Text(formatDateAndTime(firestoreManager.user?.userSince) )
                    .foregroundColor(.primary.opacity(0.7))
            }

            Text(firestoreManager.user?.description ?? "User Description")
                .foregroundColor(.primary.opacity(0.7))

            AngularButton(title: "Log out") {
                do{
                    try Auth.auth().signOut()
                    dismiss()
                }catch let error{
                    alert.alert.title = "Something is wrong!"
                    alert.alert.message = error.localizedDescription
                    alert.showAlert.toggle()
                }
            }.padding(.top,40)
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16,style: .continuous))
        .overlay{
            RoundedRectangle(cornerRadius: 16,style: .continuous).stroke(.white.opacity(0.2))
        }
        .shadow(radius: 8)
    }
    
    func fetchUser() {
        if let currentUser = Auth.auth().currentUser {
            firestoreManager.getUserDetails(with: currentUser.uid) { fetchedUser, error in
                if (error == nil){
                    firestoreManager.user = fetchedUser
                    print("USER : \(String(describing: fetchedUser))")
                }
            }
        }
    }
    func formatDateAndTime(_ date: Date?) -> String {
        if let date {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy - h:mm a" // Customize the format as needed
            return formatter.string(from: date)
        }
        else{
            return "-"
        }

    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AlertManager())
            .environmentObject(FirestoreManager())
    }
}
