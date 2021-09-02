
import SwiftUI

struct HomeFeedScreen: View {
    @Binding var tabSelection: Int
    @EnvironmentObject var session: SessionStore
    @ObservedObject var viewModel = FeedViewModel()
    
    var body: some View {
        NavigationView{
            ZStack{
                List{
                    ForEach(viewModel.items, id:\.self){ item in
                        if let uid = session.session?.uid! {
                            FeedPostCell(uid:uid, viewModel: viewModel, post: item)
                                .listRowInsets(EdgeInsets())
                        }
                    }
                }
                .listStyle(PlainListStyle())
                
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            
            .navigationBarItems(trailing:
                                    Button(action: {
                                        self.tabSelection = 2
                                    }, label: {
                                        Image(systemName: "camera")
                                    })
            )
            .navigationBarTitle("Instagram",displayMode: .inline)
        }.onAppear{
            if let uid = session.session?.uid! {
                viewModel.apiFeedList(uid: uid)
            }
        }
    }
}

struct HomeFeedScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeFeedScreen(tabSelection: .constant(0))
    }
}
