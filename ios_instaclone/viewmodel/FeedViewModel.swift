

import Foundation

class FeedViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var items: [Post] = []
    
    func apiFeedList(uid: String) {
        isLoading = true
        items.removeAll()
        
        DatabaseStore().loadFeeds(uid: uid, completion: {posts in
            self.items = posts!
            self.isLoading = false
        })
    }
    
    func apiLikePost(uid: String, post: Post) {
        DatabaseStore().likeFeedPost(uid: uid, post: post)
    }
    
    func apiRemovePost(uid: String, post: Post) {
        DatabaseStore().removeMyPost(uid: uid, post: post)
        apiFeedList(uid: uid)
    }
}
