

import Foundation
import FirebaseFirestore

class DatabaseStore: ObservableObject {
    var USER_PATH  = "users"
    var POST_PATH  = "posts"
    var FEED_PATH  = "feeds"
    var FOLLOWING_PATH  = "following"
    var FOLLOWERS_PATH  = "followers"
    
    let store = Firestore.firestore()
    
    func storeUser(user: User) {
        
        // device_type = "I"
        // device_id = "37F0CE0B-E804-4C89-B377-F96BD03B0D9B"
        // device_token = "asjhdjashdjashdjahsdjahsdajshdajsdhakdaksjdha..."
        
        let device_type = "I"
        let device_id = UIDevice.current.identifierForVendor?.uuidString
        let device_token = ""
        
        let params = ["uid": user.uid, "email": user.email,"displayName": user.displayName,"password": user.password
                      ,"device_type": device_type
                      ,"device_id": device_id
                      ,"device_token": device_token]
        store.collection(USER_PATH).document(user.uid!).setData(params)
    }
    
    func loadUser(uid: String, completion: @escaping (User?) -> ()) {
        print(uid)
        store.collection(USER_PATH).document(uid).getDocument(completion: {(document, error) in
            if let document = document, document.exists {
                let docData = document.data()
                // Do something with doc data
                
                let uid = docData!["uid"] as? String ?? ""
                let email = docData!["email"] as? String ?? ""
                let displayName = docData!["displayName"] as? String ?? ""
                let imgUser = docData!["imgUser"] as? String ?? ""
                var user = User(email: email, displayName: displayName, imgUser: imgUser)
                user.uid = uid
                completion(user)
            } else {
                print("Document does not exist")
                completion(nil)
            }
        })
    }
    
    func loadUsers(keyword: String,completion: @escaping ([User]?) -> ()) {
        var items: [User] = []
        
        store.collection(USER_PATH)
            .whereField("displayName", isGreaterThanOrEqualTo: keyword)
            .whereField("displayName", isLessThan: keyword + "z")
            .addSnapshotListener{ (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No users")
                    return
                }
                documents.compactMap{ document in
                    let uid = document["uid"] as? String ?? ""
                    let email = document["email"] as? String ?? ""
                    let displayName = document["displayName"] as? String ?? ""
                    let imgUser = document["imgUser"] as? String ?? ""
                    let user = User(uid: uid, email: email, displayName: displayName, imgUser: imgUser)
                    items.append(user)
                }
                completion(items)
            }
    }
    
    
    func updateMyImage(uid: String, imgUser: String?) {
        store.collection(USER_PATH).document(uid).updateData(["imgUser": imgUser!])
    }
    
    func storePost(post: Post,completion: @escaping (Bool) -> ()) {
        let postId = store.collection(USER_PATH).document(post.uid!).collection(POST_PATH).document().documentID
        
        let params = [
            "postId": postId,
            "time": Utils.currentDate(),
            "caption": post.caption,
            "imgPost": post.imgPost,
            "uid": post.uid,
            "displayName": post.displayName,
            "imgUser": post.imgUser]
        
        if let uid = post.uid{
            do {
                try store.collection(USER_PATH).document(uid).collection(POST_PATH).document(postId).setData(params)
                try store.collection(USER_PATH).document(uid).collection(FEED_PATH).document(postId).setData(params)
                completion(true)
            }catch {
                print("There was an error while trying to update a task \(error.localizedDescription).")
                completion(false)
            }
        }
    }
    
    func loadFeeds(uid:String, completion: @escaping ([Post]?) -> ()) {
        var items: [Post] = []
        
        store.collection(USER_PATH).document(uid).collection(FEED_PATH).getDocuments{ querySnapshot, error in
            if let documents = querySnapshot?.documents {
                documents.compactMap{ document in
                    let postId = document["postId"] as? String ?? ""
                    let caption = document["caption"] as? String ?? ""
                    let imgPost = document["imgPost"] as? String ?? ""
                    
                    let displayName = document["displayName"] as? String ?? ""
                    let imgUser = document["imgUser"] as? String ?? ""
                    let time = document["time"] as? String ?? ""
                    let uid = document["uid"] as? String ?? ""
                    
                    let isLiked = document["isLiked"] as? Bool ?? false
                    
                    var post = Post(postId:postId, caption: caption, imgPost: imgPost)
                    post.displayName = displayName
                    post.imgUser = imgUser
                    post.time = time
                    post.uid = uid
                    post.isLiked = isLiked
                    
                    items.append(post)
                }
                completion(items)
            }
        }
    }
    
    func loadPosts(uid:String, completion: @escaping ([Post]?) -> ()) {
        var items: [Post] = []
        
        store.collection(USER_PATH).document(uid).collection(POST_PATH).getDocuments{ querySnapshot, error in
            if let documents = querySnapshot?.documents {
                documents.compactMap{ document in
                    let postId = document["postId"] as? String ?? ""
                    let caption = document["caption"] as? String ?? ""
                    let imgPost = document["imgPost"] as? String ?? ""
                    
                    let displayName = document["displayName"] as? String ?? ""
                    let imgUser = document["imgUser"] as? String ?? ""
                    let time = document["time"] as? String ?? ""
                    let uid = document["uid"] as? String ?? ""
                    
                    let isLiked = document["isLiked"] as? Bool ?? false
                    
                    var post = Post(postId:postId, caption: caption, imgPost: imgPost)
                    post.displayName = displayName
                    post.imgUser = imgUser
                    post.time = time
                    post.uid = uid
                    post.isLiked = isLiked
                    
                    items.append(post)
                }
                completion(items)
            }
        }
    }
    
    // Follow, Un Follow
    
    func followUser(me: User, to: User,completion: @escaping (Bool) -> ()) {
        
        let paramsMe = ["uid": me.uid, "displayName": me.displayName, "imgUser": me.imgUser]
        
        let paramsTo = ["uid": to.uid, "displayName": to.displayName, "imgUser": to.imgUser]
        
        do {
            // I followed to someone
            try store.collection(USER_PATH).document(me.uid!).collection(FOLLOWING_PATH).document(to.uid!).setData(paramsTo)
            
            // I am in someone`s followers
            try store.collection(USER_PATH).document(to.uid!).collection(FOLLOWERS_PATH).document(me.uid!).setData(paramsMe)
            
            self.storePostsToMyFeed(uid: me.uid!, to: to)
            completion(true)
        }catch {
            print("There was an error while trying to follow user \(error.localizedDescription).")
            completion(false)
        }
    }
    
    func unFollowUser(me: User, to: User,completion: @escaping (Bool) -> ()) {
        
        let paramsMe = ["uid": me.uid, "displayName": me.displayName, "imgUser": me.imgUser]
        
        let paramsTo = ["uid": to.uid, "displayName": to.displayName, "imgUser": to.imgUser]
        
        do {
            // I un followed to someone
            try store.collection(USER_PATH).document(me.uid!).collection(FOLLOWING_PATH).document(to.uid!).delete()
            
            // I am not in someone`s followers
            try store.collection(USER_PATH).document(to.uid!).collection(FOLLOWERS_PATH).document(me.uid!).delete()
            
            self.removePostsFromMyFeed(uid: me.uid!, to: to)
            completion(true)
        }catch {
            print("There was an error while trying to follow user \(error.localizedDescription).")
            completion(false)
        }
    }
    
    func storePostsToMyFeed(uid: String, to: User){
        loadPosts(uid: to.uid!){ posts in
            for post in posts! {
                self.storeFeed(uid: uid, post: post)
            }
        }
    }
    
    func storeFeed(uid: String, post: Post) {
        
        let params = [
            "postId": post.postId,
            "time": post.time,
            "caption": post.caption,
            "imgPost": post.imgPost,
            "uid": post.uid,
            "displayName": post.displayName,
            "imgUser": post.imgUser]
        
        if let postId = post.postId{
            do {
                try store.collection(USER_PATH).document(uid).collection(FEED_PATH).document(postId).setData(params)
            }catch {
                print("There was an error while trying to store feed \(error.localizedDescription).")
            }
        }
    }
    
    func removePostsFromMyFeed(uid: String, to: User){
        loadPosts(uid: to.uid!){ posts in
            for post in posts! {
                self.removeFeed(uid: uid, post: post)
            }
        }
    }
    
    func removeFeed(uid: String, post: Post) {
        
        if let postId = post.postId{
            do {
                try store.collection(USER_PATH).document(uid).collection(FEED_PATH).document(postId).delete()
            }catch {
                print("There was an error while trying to delete feed \(error.localizedDescription).")
            }
        }
    }
    
    
    func loadFollowing(uid: String,completion: @escaping ([User]?) -> ()) {
        var items: [User] = []
        
        store.collection(USER_PATH).document(uid).collection(FOLLOWING_PATH).addSnapshotListener{ (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No users")
                    return
                }
                documents.compactMap{ document in
                    let uid = document["uid"] as? String ?? ""
                    let email = document["email"] as? String ?? ""
                    let displayName = document["displayName"] as? String ?? ""
                    let imgUser = document["imgUser"] as? String ?? ""
                    let user = User(uid: uid, email: email, displayName: displayName, imgUser: imgUser)
                    items.append(user)
                }
                completion(items)
            }
    }
    
    func loadFollowers(uid: String,completion: @escaping ([User]?) -> ()) {
        var items: [User] = []
        
        store.collection(USER_PATH).document(uid).collection(FOLLOWERS_PATH).addSnapshotListener{ (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No users")
                    return
                }
                documents.compactMap{ document in
                    let uid = document["uid"] as? String ?? ""
                    let email = document["email"] as? String ?? ""
                    let displayName = document["displayName"] as? String ?? ""
                    let imgUser = document["imgUser"] as? String ?? ""
                    let user = User(uid: uid, email: email, displayName: displayName, imgUser: imgUser)
                    items.append(user)
                }
                completion(items)
            }
    }
    
    func likeFeedPost(uid: String, post: Post) {

        if let postId = post.postId{
            do {
                try store.collection(USER_PATH).document(uid).collection(FEED_PATH).document(postId).updateData(["isLiked": post.isLiked!])
                if post.uid == uid {
                    store.collection(USER_PATH).document(uid).collection(POST_PATH).document(postId).updateData(["isLiked": post.isLiked!])
                }
            }catch {
                print("There was an error while trying to delete feed \(error.localizedDescription).")
            }
        }
    }
    
    func loadLikes(uid:String, completion: @escaping ([Post]?) -> ()) {
        var items: [Post] = []
        
        store.collection(USER_PATH).document(uid).collection(FEED_PATH).whereField("isLiked", isEqualTo: true).getDocuments{ querySnapshot, error in
            if let documents = querySnapshot?.documents {
                documents.compactMap{ document in
                    let postId = document["postId"] as? String ?? ""
                    let caption = document["caption"] as? String ?? ""
                    let imgPost = document["imgPost"] as? String ?? ""
                    
                    let displayName = document["displayName"] as? String ?? ""
                    let imgUser = document["imgUser"] as? String ?? ""
                    let time = document["time"] as? String ?? ""
                    let uid = document["uid"] as? String ?? ""
                    
                    let isLiked = document["isLiked"] as? Bool ?? false
                    
                    var post = Post(postId:postId, caption: caption, imgPost: imgPost)
                    post.displayName = displayName
                    post.imgUser = imgUser
                    post.time = time
                    post.uid = uid
                    post.isLiked = isLiked
                    
                    items.append(post)
                }
                completion(items)
            }
        }
    }
    
    func removeMyPost(uid: String, post: Post) {
        
        if let postId = post.postId{
            do {
                try store.collection(USER_PATH).document(uid).collection(FEED_PATH).document(postId).delete()
                try store.collection(USER_PATH).document(uid).collection(POST_PATH).document(postId).delete()
            }catch {
                print("There was an error while trying to delete feed \(error.localizedDescription).")
            }
        }
    }
}
