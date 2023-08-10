//
//  SettingView.swift
//  Auth_SwiftUi
//
//  Created by Milad Khalighi on 2023-08-02.
//

import SwiftUI
import FirebaseAuth

enum StateView {case loading; case loaded; case error}
struct SettingView: View {
    
    @State var selectedIndex = 0
    @State var textName = ""
    @State var textBio = ""
    @State var textWebsite = ""
    @State var textDescription = ""
    
    @EnvironmentObject var firestoreManager : FirestoreManager
    @EnvironmentObject var alert : AlertManager
    @State var showLoading = true
    @Environment(\.dismiss) var dismiss
    
    @State var showImagePicker = false
    @State var inputIamge : UIImage?
    
    @EnvironmentObject var storageManager : FStorageManager
    
    var body: some View {
        NavigationStack{
                ScrollView {
                    
                    if(showLoading){
                        ProgressView()
                            .padding(.top,100)
                    }
                    else{
                        VStack(alignment : .leading, spacing: 16){
                            
                            Text("Manage your profile and account")
                                .padding(.bottom,10)
                                .font(.footnote)
                                .foregroundColor(.white)
                            
                            photoView
                            .padding(.bottom,20)
                            
                            IconEditTextRow(
                                icon: "textformat.alt",
                                titlePlaceholder: firestoreManager.user?.name ?? "Name",
                                text: $textName,
                                itemSelected: .constant(selectedIndex==1 ? true : false)
                            ).onTapGesture {withAnimation(.easeInOut) {selectedIndex = 1}}
                            IconEditTextRow(
                                icon: "scribble.variable",
                                titlePlaceholder: "bio",
                                text: $textBio,
                                itemSelected: .constant(selectedIndex==2 ? true : false)
                            ).onTapGesture {withAnimation(.easeInOut) {selectedIndex = 2}}
                            IconEditTextRow(
                                icon: "link",
                                titlePlaceholder: "website",
                                text: $textWebsite,
                                itemSelected: .constant(selectedIndex==3 ? true : false)
                            ).onTapGesture {withAnimation(.easeInOut) {selectedIndex = 3}}
                            IconEditTextRow(
                                icon: "line.3.horizontal.decrease",
                                titlePlaceholder: "description",
                                text: $textDescription,
                                itemSelected: .constant(selectedIndex==4 ? true : false)
                            ).onTapGesture {withAnimation(.easeInOut) {selectedIndex = 4}}
                            
                            
                            AngularButton(title: "Save Settings") {
                                save()
                            }
                            .padding(.top,30)
                            
                        }
                        .padding(20)
                    }
                    
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("settingsBackground").opacity(0.8))
                .navigationTitle("Settings")
            
        }.onAppear {
             fetchUser()
        }
        .alert(alert.alert.title, isPresented: $alert.showAlert) {
            Button("Got it!") {
                if(alert.alert.title == "Saved data!"){
                    dismiss()
                }
            }
        } message: {
            Text(alert.alert.message)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $inputIamge)
        }

        
    }
    
    var photoView : some View {
        Button {
            showImagePicker.toggle()
        } label: {
            HStack(spacing: 16){
                if(inputIamge==nil){
                    AngularIcon(icon: "person.crop.circle",iconSize: 46, selected: .constant(false))
                }
                else{
                    Image(uiImage: inputIamge!)
                        .resizable()
                        .frame(width: 46,height: 46)
                        .aspectRatio(contentMode: .fill)
                        .mask(RoundedRectangle(cornerRadius: 12,style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color("pink-gradient-2").opacity(0.5))
                        }
                }
                Text("choose photo")
                    .font(.headline.weight(.bold))
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 64)
            .padding(.horizontal,8)
            .background(Color("secondaryBackground").opacity(0.5), in: RoundedRectangle(cornerRadius: 16,style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 16,style: .continuous).stroke(.gray)
            }
        }
        .foregroundColor(.white)

    }
    
    func save() {
        if let currentUser = Auth.auth().currentUser {
            showLoading.toggle()
            if !textName.isEmpty{
                firestoreManager.user?.name = textName
            }
            if !textWebsite.isEmpty{
                firestoreManager.user?.website = textWebsite
            }
            if !textBio.isEmpty{
                firestoreManager.user?.bio = textBio
            }
            if !textDescription.isEmpty{
                firestoreManager.user?.description = textDescription
            }
            firestoreManager.user?.email = currentUser.email
            
            if let inputIamge = inputIamge {
                storageManager.uploadImageToFirebaseStorage(image: inputIamge) { result in
                    switch result {
                    case .success(let photoUrl):
                        
                        firestoreManager.user?.photoUrl = photoUrl.absoluteString
                        //print(photoUrl)
                        if let user = firestoreManager.user {
                            firestoreManager.saveUser(user, completion: { err in
                                if let error = err {
                                    alert.alert.title = "Can not save data"
                                    alert.alert.message = error.localizedDescription
                                    alert.showAlert = true
                                }
                                else{
                                    alert.alert.title = "Saved data!"
                                    alert.alert.message = "User data has successfully saved"
                                    alert.showAlert = true
                                }
                                showLoading.toggle()
                            })
                        }
                        else{
                            alert.alert.title = "Can not save data"
                            alert.alert.message = "something went wrong!"
                            alert.showAlert = true
                        }

                        
                    case .failure(let error):
                        
                        alert.alert.title = "Can not save photo"
                        alert.alert.message = error.localizedDescription
                        alert.showAlert = true
                        showLoading.toggle()
                    }
                }
            }
            

        }

    }
    
    
    func fetchUser() {
        if let currentUser = Auth.auth().currentUser {
            firestoreManager.getUserDetails(with: currentUser.uid) { fetchedUser, error in
                if let error = error {
                    alert.alert.title = "Can not fetch user data from server"
                    alert.alert.message = error.localizedDescription
                    alert.showAlert = true
                }
                else{
                    textName = fetchedUser?.name ?? ""
                    textBio = fetchedUser?.bio ?? ""
                    textWebsite = fetchedUser?.website ?? ""
                    textDescription = fetchedUser?.description ?? ""
                    showLoading.toggle()
                    firestoreManager.user = fetchedUser
                    
                    if let url = fetchedUser?.photoUrl{
                        if let data = try? Data(contentsOf: URL(string: url)!){
                            inputIamge = UIImage(data: data)
                        }
                        
                    }

                }
            }
        }
    }
    
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(showLoading: false)
            .environmentObject(FirestoreManager())
            .environmentObject(AlertManager())
            .environmentObject(FStorageManager())
    }
}
