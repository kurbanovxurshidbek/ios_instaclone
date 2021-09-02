

import SwiftUI
import SDWebImageSwiftUI

struct FeedPostCell: View {
    @State private var showingAlert = false
    var uid: String
    var viewModel: FeedViewModel
    @State var post: Post
    
    var body: some View {
        VStack(spacing: 0){
            HStack(spacing: 0){
                VStack{
                    if !post.imgUser!.isEmpty{
                        WebImage(url: URL(string:post.imgUser!))
                            .resizable()
                            .clipShape(Circle())
                            .frame(height:46)
                            .frame(width:46)
                            .padding(.all, 2)
                    }else{
                        Image("ic_person")
                            .resizable()
                            .clipShape(Circle())
                            .frame(height:46)
                            .frame(width:46)
                            .padding(.all, 2)
                    }
                }.overlay(RoundedRectangle(cornerRadius: 25)
                            .stroke(Utils.color2, lineWidth: 2))
                
                VStack(alignment: .leading,spacing: 3){
                    Text(post.displayName!)
                        .foregroundColor(.black)
                        .font(.system(size: 17))
                        .fontWeight(.medium)
                    
                    Text(post.time!)
                        .foregroundColor(.gray)
                        .font(.system(size: 15))
                }.padding(.leading, 15)
                
                Spacer()
                
                Button(action: {
                    self.showingAlert = true
                }, label: {
                    if uid == post.uid {
                        Image("ic_more")
                    }
                })
                .buttonStyle(PlainButtonStyle())
                .alert(isPresented: $showingAlert) {
                    let title = "Delete"
                    let message = "Do you want to delete this post?"
                    return Alert(title: Text(title), message: Text(message), primaryButton: .destructive(Text("Confirm"), action: {
                        // Some action
                        viewModel.apiRemovePost(uid: uid, post: post)
                    }), secondaryButton: .cancel())
                }
            }
            .padding(.leading,15)
            .padding(.trailing,15)
            .padding(.top, 15)
            
            WebImage(url: URL(string:post.imgPost!))
                .resizable().scaledToFit()
                .padding(.top, 15)
            
            
            HStack(spacing: 0){
                Button(action: {
                    if post.isLiked! {
                        post.isLiked = false
                    }else{
                        post.isLiked = true
                    }
                    viewModel.apiLikePost(uid: uid, post: post)
                }, label: {
                    if post.isLiked!{
                        Image("ic_like_on").resizable().frame(height:26).frame(width:26)
                    }else{
                        Image("ic_like_off").resizable().frame(height:26).frame(width:26)
                    }
                })
                Button(action: {
                    
                }, label: {
                    Image("ic_share").resizable().frame(height:26).frame(width:26)
                }).padding(.leading,15)
                Spacer()
            }
            .padding(.leading,15)
            .padding(.trailing,15)
            .padding(.top,15)
            
            HStack(spacing: 0){
                Text(post.caption!)
                    .foregroundColor(.black)
                    .font(.system(size: 16))
                Spacer()
            }.padding(.all,15)

        }
    }
}

struct FeedPostCell_Previews: PreviewProvider {
    static var previews: some View {
        FeedPostCell(uid: "uid", viewModel: FeedViewModel(), post: Post(caption: "symbolic", imgPost: Utils.image1))
    }
}
