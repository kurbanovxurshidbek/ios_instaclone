

import SwiftUI

struct StarterScreen: View {
    @EnvironmentObject var session: SessionStore
    
    var body: some View {
        VStack{
            if self.session.session != nil {
                HomeScreen()
            }else{
                SignInScreen()
            }
        }.onAppear{
            session.listen()
        }
    }
}

struct StarterScreen_Previews: PreviewProvider {
    static var previews: some View {
        StarterScreen()
    }
}
