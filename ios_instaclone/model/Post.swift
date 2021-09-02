

import Foundation

struct Post: Hashable {
    var id = UUID()
    
    var postId: String? = ""
    var caption: String? = ""
    var imgPost: String? = ""
    var time: String? = "February 2, 2021"
    
    var uid: String? = ""
    var displayName: String? = "khurshid88"
    var imgUser: String? = ""
    
    var isLiked: Bool? = false
    
    init(caption: String?, imgPost: String?) {
        self.caption = caption
        self.imgPost = imgPost
    }
    
    init(postId: String, caption: String?, imgPost: String?) {
        self.postId = postId
        self.caption = caption
        self.imgPost = imgPost
    }
}
