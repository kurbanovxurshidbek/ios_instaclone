
import Foundation
import SwiftUI
import Firebase
import FirebaseStorage

class StorageStore: ObservableObject {
    let storageRef = Storage.storage().reference()
    
    func uploadUserImage(uid: String, _ image: UIImage, completion: @escaping (String) -> Void) {
        let imageRef = storageRef.child("users/" + uid + ".jpg")
        
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
            return completion("")
        }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        imageRef.putData(imageData, metadata: metadata, completion: { [self] (metadata, error) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion("")
            }
            imageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    return completion("")
                }
                let downloadUrl = String(describing: url!)
                completion(downloadUrl)
            })
        })
    }
    
    func timeString() -> String {
        let now = Date()
        let formatter = ISO8601DateFormatter()
        let datetime = formatter.string(from: now)
        print(datetime)
        return datetime
    }
    
    func uploadPostImage(uid: String, _ image: UIImage, completion: @escaping (String) -> Void) {
        let imageRef = storageRef.child("posts/" + uid + timeString() + ".jpg")
        
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
            return completion("")
        }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        imageRef.putData(imageData, metadata: metadata, completion: { [self] (metadata, error) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion("")
            }
            imageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    return completion("")
                }
                let downloadUrl = String(describing: url!)
                completion(downloadUrl)
            })
        })
    }
}
