

import Foundation

class SignInViewModel: ObservableObject {
    
    @Published var isLoading = false
    
    
    func apiSignIn(email: String, password: String, completion: @escaping (Bool) -> ()){
        isLoading = true
        SessionStore().signIn(email: email, password: password, handler: {(res,err) in
            self.isLoading = false
            if err != nil {
                print("Check email or password")
                completion(false)
            }else{
                print("User signed in")
                completion(true)
            }
        })
    }
    
}
