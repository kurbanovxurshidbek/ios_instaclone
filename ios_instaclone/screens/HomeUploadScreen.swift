
import SwiftUI

struct HomeUploadScreen: View {
    @Binding var tabSelection: Int
    
    @EnvironmentObject var session: SessionStore
    @ObservedObject var viewModel = UploadViewModel()
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var showActionSheet = false
    @State private var isImagePickerDisplay = false
    @State var caption = ""
    
    func uploadPost(){
        if caption.isEmpty || selectedImage == nil{
            return
        }
        // Send post to server
        let uid = (session.session?.uid)!
        viewModel.apiUploadPost(uid: uid, caption: caption, image: selectedImage!){result in
            if result {
                self.selectedImage = nil
                self.caption = ""
                self.tabSelection = 0
            }
        }
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                VStack{
                    ZStack{
                        if selectedImage != nil {
                            Image(uiImage: selectedImage!)
                                .resizable()
                                .frame(maxWidth: UIScreen.width, maxHeight: UIScreen.width).scaledToFill()
                            
                            VStack{
                                HStack{
                                    Spacer()
                                    Button(action: {
                                        selectedImage = nil
                                    }, label: {
                                        Image(systemName: "xmark.square").resizable().scaledToFit().frame(width: 25, height: 25)
                                    }).padding()
                                }
                                Spacer()
                            }
                        }else{
                            Button(action: {
                                showActionSheet = true
                            }, label: {
                                Image(systemName: "camera").resizable().scaledToFit().frame(width: 40, height: 40)
                            })
                            .actionSheet(isPresented: $showActionSheet) {
                                        ActionSheet(
                                            title: Text("Actions"),
                                            buttons: [
                                                .cancel { print(self.showActionSheet) },
                                                .default(Text("Pick Photo")){
                                                    self.sourceType = .photoLibrary
                                                    self.isImagePickerDisplay.toggle()
                                                },
                                                .default(Text("Take Photo")){
                                                    self.sourceType = .camera
                                                    self.isImagePickerDisplay.toggle()
                                                },
                                            ]
                                        )
                                    }
                            .sheet(isPresented: self.$isImagePickerDisplay) {
                                ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
                            }
                        }
                        
                    }
                    .frame(maxWidth: UIScreen.width, maxHeight: UIScreen.width)
                    .background(Color.gray.opacity(0.2))
                    
                    VStack{
                        TextField("Caption", text: $caption)
                            .font(Font.system(size: 17, design: .default))
                            .frame(height: 45)
                        Divider()
                    }.padding(.top, 10).padding(.leading, 20).padding(.trailing, 20)
                    
                    Spacer()
                }
                
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .navigationBarItems(trailing:
                                    Button(action: {
                                        self.uploadPost()
                                    }, label: {
                                        Image(systemName: "square.and.arrow.up")
                                    })
            )
            .navigationBarTitle("Upload",displayMode: .inline)
        }
    }
}

struct HomeUploadScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeUploadScreen(tabSelection: .constant(0))
    }
}
