

import SwiftUI
import SDWebImageSwiftUI

struct MyPostCell: View {
    var uid: String
    var viewModel: ProfileViewModel
    @State private var showingAlert = false
    var post: Post
    var length: CGFloat
    
    var body: some View {
        VStack(spacing: 0){
            WebImage(url: URL(string:post.imgPost!))
                .resizable()
                .frame(width: length, height: length)
                .scaledToFit()
                .onLongPressGesture {
                    self.showingAlert = true
                }
                .alert(isPresented: $showingAlert) {
                    let title = "Delete"
                    let message = "Do you want to delete this post?"
                    return Alert(title: Text(title), message: Text(message), primaryButton: .destructive(Text("Confirm"), action: {
                        // Some action
                        viewModel.apiRemovePost(uid: uid, post: post)
                    }), secondaryButton: .cancel())
                }
            
            Text(post.caption!)
                .foregroundColor(.black)
                .font(.system(size: 16))
                .padding(.top, 10)
                .padding(.bottom, 10)
                .frame(width: length)
        }
    }
}

struct MyPostCell_Previews: PreviewProvider {
    static var previews: some View {
        MyPostCell(uid: "uid", viewModel: ProfileViewModel(),post: Post(caption: "khurshid88", imgPost: Utils.image2),length: UIScreen.width)
    }
}
