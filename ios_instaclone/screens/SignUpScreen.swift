

import SwiftUI

struct SignUpScreen: View {
    @EnvironmentObject var session: SessionStore
    
    @ObservedObject var viewModel = SignUpViewModel()
    @Environment(\.presentationMode) var presentation
    @State var isLoading = false
    @State var fullname = "Xurshidbek"
    @State var email = "khurshid@gmail.com"
    @State var password = "123qwe"
    @State var cpassword = ""
    
    func doSignUp(){
        viewModel.apiSignUp(email: email, password: password, completion: {result in
            if !result{
                // when error, show dialog or toast
            }else{
                //save user to Firestore
                var user = User(email: email, displayName: fullname, password: password, imgUser: "")
                user.uid = session.session?.uid
                viewModel.apiStoreUser(user: user)
                presentation.wrappedValue.dismiss()
            }
        })
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                LinearGradient(gradient: Gradient(colors: [Utils.color1,Utils.color2]), startPoint: .bottom, endPoint: .top)
                
                VStack(spacing: 0){
                    Spacer()
                    
                    Text("app_name").foregroundColor(.white)
                        .font(Font.custom("Billabong", size: 45))
                    
                    TextField("fullname", text: $fullname)
                        .frame(height: 50).padding(.leading,10)
                        .foregroundColor(.white)
                        .background(Color.white.opacity(0.4)).cornerRadius(8)
                        .padding(.top,10)
                    
                    TextField("email", text: $email)
                        .frame(height: 50).padding(.leading,10)
                        .foregroundColor(.white)
                        .background(Color.white.opacity(0.4)).cornerRadius(8)
                        .padding(.top,10)
                    
                    TextField("password", text: $password)
                        .frame(height: 50).padding(.leading,10)
                        .foregroundColor(.white)
                        .background(Color.white.opacity(0.4)).cornerRadius(8)
                        .padding(.top,10)
                    
                    TextField("cpassword", text: $cpassword)
                        .frame(height: 50).padding(.leading,10)
                        .foregroundColor(.white)
                        .background(Color.white.opacity(0.4)).cornerRadius(8)
                        .padding(.top,10)
                    
                    Button(action: {
                        doSignUp()
                    }, label: {
                        Text("sign_up")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(lineWidth: 1.5)
                                    .foregroundColor(.white.opacity(0.4))
                            )
                    }).padding(.top,10)
                    Spacer()
                    
                    VStack{
                        
                        HStack{
                            Text("already_have_account").foregroundColor(.white)
                            Button(action: {
                                self.presentation.wrappedValue.dismiss()
                            }, label: {
                                Text("sign_in").foregroundColor(.white).fontWeight(.bold)
                            })
                            
                        }
                    }.frame(maxWidth:.infinity, maxHeight: 70)
                    
                }.padding()
                
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .edgesIgnoringSafeArea(.all)
            
        }
        .navigationBarBackButtonHidden(true)
        .accentColor(.white)

    }
}

struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignUpScreen()
    }
}
