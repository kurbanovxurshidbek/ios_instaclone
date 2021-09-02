
import Foundation

class LikesViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var items: [Post] = []
    
    func apiLikesList(uid: String) {
        isLoading = true
        items.removeAll()
        
        DatabaseStore().loadLikes(uid: uid, completion: {posts in
            self.items = posts!
            self.isLoading = false
        })
    }
    
    func apiLikePost(uid: String, post: Post) {
        DatabaseStore().likeFeedPost(uid: uid, post: post)
        apiLikesList(uid: uid)
    }
    
    func apiRemovePost(uid: String, post: Post) {
        DatabaseStore().removeMyPost(uid: uid, post: post)
        apiLikesList(uid: uid)
    }
}
