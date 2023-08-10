//
//  StorageManager.swift
//  Auth_SwiftUi
//
//  Created by Milad Khalighi on 2023-08-05.
//

import Foundation
import FirebaseStorage
import SwiftUI



class FStorageManager : ObservableObject {
    @Published var image : UIImage?
    
    let storageRef = Storage.storage()
    
    func uploadImageToFirebaseStorage(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            let error = NSError(domain: "Image conversion error", code: -1, userInfo: nil)
            completion(.failure(error))
            return
        }
        
        let storageRef = Storage.storage().reference().child("images").child("\(UUID().uuidString).jpg")

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        storageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                completion(.failure(error))
            } else {
                storageRef.downloadURL { url, error in
                    if let downloadURL = url {
                        completion(.success(downloadURL))
                    } else {
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            let unknownError = NSError(domain: "Unknown error", code: -1, userInfo: nil)
                            completion(.failure(unknownError))
                        }
                    }
                }
            }
        }
    }
    
    func downloadImage(from imageURL: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.image = image
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }.resume()
    }
    
    
    func compressImage(_ image: UIImage) -> Data? {
        let compressionQuality: CGFloat = 0.5 // Adjust the quality as needed (0.0 to 1.0)
        return image.jpegData(compressionQuality: compressionQuality)
    }
}
