

import Foundation

struct User: Hashable  {
    
    var uid: String?
    var email: String?
    var displayName: String?
    var password: String?
    var imgUser: String?
    
    var isFollowed: Bool = false
    
    init(email: String, displayName: String?, password: String?, imgUser: String?) {
        self.email = email
        self.displayName = displayName
        self.password = password
        self.imgUser = imgUser
    }
    
    init(uid: String,displayName: String?, email: String?) {
        self.uid = uid
        self.email = email
        self.displayName = displayName
    }
    
    init(email: String,displayName: String?, imgUser: String?) {
        self.email = email
        self.displayName = displayName
        self.imgUser = imgUser
    }
    
    init(uid: String, email: String,displayName: String?, imgUser: String?) {
        self.uid = uid
        self.email = email
        self.displayName = displayName
        self.imgUser = imgUser
    }
    
}
