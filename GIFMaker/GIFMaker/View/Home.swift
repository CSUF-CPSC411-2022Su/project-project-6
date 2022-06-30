
//  Home.swift
//  GIFMaker
//
//  Created by csuftitan on 6/21/22.
//

import Firebase
import GoogleSignIn
import PhotosUI
import SwiftUI

struct Home: View {
    // Login Status
    @AppStorage("log_status") var logStatus: Bool = false
    
    // Note: FaceID Properties
    @AppStorage("use_face_id") var useFaceID: Bool = false
    @AppStorage("use_face_email") var faceIDEmail: String = ""
    @AppStorage("use_face_password") var faceIDPassword: String = ""
    
    @State var images: [UIImage] = []
    @State var picker = false
    @State public var gif_details = false
    
    @AppStorage("dynamic_name") var loginFeature: String?
    @AppStorage("create_gif_appstorage") var gif_appstorage: String?
    
    var body: some View {
        ZStack {
            Image("home-bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                if logStatus {
                    if !images.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false, content: {
                            HStack(spacing: 15) {
                                ForEach(images, id: \.self) {
                                    img in

                                    Image(uiImage: img)
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width - 225, height: 270)
                                }
                            }
                            
                        })
                        
                        VStack(spacing: 20) {
                            Text(gif_appstorage ?? "Add Name Here")

                            Button("Click Here".uppercased()) {
                                let dynamic_gif_appstorage = "Login Feature is Created By Feni"
                                gif_appstorage = dynamic_gif_appstorage
                            }
                            .padding(.horizontal, 30)
                            .foregroundColor(.white)
                            .background(Color("CherryRed"))
                        }

                        NavigationLink(destination: gifview(),
                                       label: {
                                           Text("Create GIF")
                                               .font(.body)
                                               .foregroundColor(.white)
                                       })
                                       .padding()
                                       .background {
                                           RoundedRectangle(cornerRadius: 5)
                                               .fill(Color("CherryRed"))
                                       }
                            
                                       .padding(.top, 25)
                    } else {
                        VStack(spacing: 20) {
                            Text(loginFeature ?? "Add Name Here")

                            Button("Click Here".uppercased()) {
                                let dynamic_name = "Login Feature is Created By Smit"
                                loginFeature = dynamic_name
                            }
                            .padding(.horizontal, 30)
                            .foregroundColor(.white)
                            .background(Color("CherryRed"))
                        }
                        
                        NavigationLink(destination: Explore_GIFs(), label: {
                            Text("Explore gifs")
                        })
                        .padding(.vertical, 5)
                        .padding(.horizontal, 30)
                        .foregroundColor(.white)
                        .background(Color("CherryRed"))
                        
                        NavigationLink(destination: gif_details_view(), label: {
                            Text("Downloaded GIFs")
                        })
                        .padding(.vertical, 5)
                        .padding(.horizontal, 30)
                        .foregroundColor(.white)
                        .background(Color("CherryRed"))
                        
//                        Button("Downloaded GIFs"){
//                            gif_details.toggle()
//                        }
//                        .sheet(isPresented: $gif_details){
//                            gif_details_view()
//                        }
                        
                        HStack(spacing: 5) {
                            Button(action: {
                                picker.toggle()
                            }, label: {
                                VStack(spacing: 10) {
                                    Image(systemName: "photo.on.rectangle.angled")
                                        .resizable()
                                        .frame(width: 50, height: 45)
                                        .foregroundColor(.white)
                                        .padding()
                                    Text("Select Images")
                                        .foregroundColor(.white)
                                        .font(.title2)
                                }
                                
                            })
                            .padding(.vertical, 20)
                            .padding(.horizontal, 30)
                            .background(Color("CherryRed"))
                            .cornerRadius(15)
                            Button(action: {
                                picker.toggle()
                            }, label: {
                                VStack(spacing: 10) {
                                    Image(systemName: "video.fill.badge.plus")
                                        .resizable()
                                        .frame(width: 70, height: 45)
                                        .foregroundColor(.white)
                                        .padding()
                                    Text("Select Video")
                                        .foregroundColor(.white)
                                        .font(.title2)
                                }
                                
                            })
                            .padding(.vertical, 20)
                            .padding(.horizontal, 30)
                            .background(Color("CherryRed"))
                            .cornerRadius(15)
                        }
                    }
                    
                    Button {
                        // Google Logout
                        GIDSignIn.sharedInstance.signOut()
                        
                        // Facebook Logout
                        
                        try? Auth.auth().signOut()
                        logStatus = false
                    } label: {
                        Text("Logout")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                            .hCenter()
                            .background {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color("CherryRed"))
                            }
                    }
                    .padding(.horizontal, 20)
                }
                
                if useFaceID {
                    // Clearing Face ID
                    Button("Disable FaceID") {
                        useFaceID = false
                        faceIDEmail = ""
                        faceIDPassword = ""
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 225)
            .navigationBarBackButtonHidden(true)
            .navigationTitle("GIFMaker")
            .navigationBarTitleDisplayMode(.inline)
            
            .sheet(isPresented: $picker) {
                ImagePicker(images: $images, picker: $picker)
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

// New Images Picker API
struct ImagePicker: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        return ImagePicker.Coordinator(parent1: self)
    }
    
    @Binding var images: [UIImage]
    @Binding var picker: Bool
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        // You can also select videos using this picker
        config.filter = .images
        
        // 0 is used for multiple selection
        config.selectionLimit = 0
        
        let picker = PHPickerViewController(configuration: config)
        
        // Adding Delegate
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker
        
        init(parent1: ImagePicker) {
            parent = parent1
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            // Closing Picker
            parent.picker.toggle()
            for img in results {
                if img.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    // Retreving The Selected Image
                    img.itemProvider.loadObject(ofClass: UIImage.self) { image, err in
                        
                        guard let image1 = image else {
                            print(err)
                            return
                        }
                        
                        // Appending Images
                        self.parent.images.append(image1 as! UIImage)
                    }
                
                } else {
                    // Cannot be Loaded
                    print("Cannot be Loaded")
                }
            }
        }
    }
}
