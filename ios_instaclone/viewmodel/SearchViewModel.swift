
import Foundation

class SearchViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var items: [User] = []
    
    func apiUserList(uid: String, keyword: String) {
        isLoading = true
        items.removeAll()
        
        DatabaseStore().loadUsers(keyword: keyword){ users in
            DatabaseStore().loadFollowing(uid: uid){ following in
                self.items = self.mergeUsers(uid: uid, users: users!, following: following!)
                self.isLoading = false
            }
        }
    }
    
    func mergeUsers(uid: String, users: [User], following: [User]) -> [User]{
        var items: [User] = []
        
        for u in users {
            var user = u
            for f in following {
                if u.uid == f.uid {
                    user.isFollowed = true
                    break
                }
            }
            if uid != user.uid {
                items.append(user)
            }
        }
        return items
    }
    
    func apiFollowUser(uid: String, to: User){
        DatabaseStore().loadUser(uid:uid){ me in
            DatabaseStore().followUser(me: me!, to: to){isFollowed in
                self.apiUserList(uid: uid, keyword: "")
            }
        }
    }
    
    func apiUnFollowUser(uid: String, to: User){
        DatabaseStore().loadUser(uid:uid){ me in
            DatabaseStore().unFollowUser(me: me!, to: to){isFollowed in
                self.apiUserList(uid: uid, keyword: "")
            }
        }
    }
    
}
