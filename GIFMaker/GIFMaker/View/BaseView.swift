import CoreMedia
import SwiftUI

var gifs = ["mario", "giphy", "pokeball", "pride"]
var gif_images: [UIImage]! = [UIImage(named: "Mario1")!, UIImage(named: "Mario2")!, UIImage(named: "Mario3")!, UIImage(named: "pride_01")!]

struct DetailView: View {
    @AppStorage("name") var save_to_galeery_appstorage: String?
    var body: some View {
        VStack(spacing: 20) {
            Text(save_to_galeery_appstorage ?? "Add Name Here")

            Button("Click Here".uppercased()) {
                let gif_gallery_appstorage = "Login Feature is Created By Deep"
                save_to_galeery_appstorage = gif_gallery_appstorage
            }
            .padding(.horizontal, 30)
            .foregroundColor(.white)
            .background(Color("CherryRed"))
        }
        
        List(0..<4) { item in
            GifImage(gifs[item])
                .frame(width: 200, height: 200)
            Button(action: {
                UIImageWriteToSavedPhotosAlbum(gif_images[item], nil, nil, nil)
            
            }) {
                Text("Save to Gallery")
            }
            

            var body: some View {
                Button(action: {
                    self.showsAlert = true
                }, label: {
                    Text("alert message")
                }).presentation($showsAlert, alert: {
                  Alert(title: Text("Saved Successfully"))
        })
    }
        }
    }
}
