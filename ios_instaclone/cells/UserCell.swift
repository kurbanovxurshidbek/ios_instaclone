
import SwiftUI
import SDWebImageSwiftUI

struct UserCell: View {
    var uid: String
    var user: User
    var viewModel: SearchViewModel
    
    var body: some View {
        HStack(spacing: 0){
            VStack{
                if !user.imgUser!.isEmpty{
                    WebImage(url: URL(string:user.imgUser!))
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
                Text(user.displayName!)
                    .foregroundColor(.black)
                    .font(.system(size: 17))
                    .fontWeight(.medium)
                
                Text(user.email!)
                    .foregroundColor(.gray)
                    .font(.system(size: 15))
            }.padding(.leading, 15)
            
            Spacer()
            
            Button(action: {
                if user.isFollowed {
                    viewModel.apiUnFollowUser(uid: uid, to: user)
                }else{
                    viewModel.apiFollowUser(uid: uid, to: user)
                }
            }, label: {
                if user.isFollowed {
                    Text("Following")
                        .font(.system(size: 15))
                        .foregroundColor(.black.opacity(0.5))
                        .frame(width:90, height:30)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray,lineWidth: 1))
                }else{
                    Text("Follow")
                        .font(.system(size: 15))
                        .foregroundColor(.black.opacity(0.5))
                        .frame(width:90, height:30)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray,lineWidth: 1))
                }
                
            })
        }.padding(.all,20)
    }
}

struct UserCell_Previews: PreviewProvider {
    static var previews: some View {
        UserCell(uid: "uid", user: User(uid: "1", displayName: "khurshid88", email: "shamsun.com@gmail.com"),viewModel: SearchViewModel())
    }
}
