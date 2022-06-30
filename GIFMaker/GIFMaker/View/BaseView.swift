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
        }
    }
}

struct gif_details_view: View {
    @State public var details_gif = false
    @AppStorage("name") var dynamic_download_gif: String?
    var body: some View {
        VStack(spacing: 20) {
            Text(dynamic_download_gif ?? "Add Name Here")

            Button("Click Here".uppercased()) {
                let download_gif_appstorage = "Login Feature is Created By Kevin"
                dynamic_download_gif = download_gif_appstorage
            }
            .padding(.horizontal, 30)
            .foregroundColor(.white)
            .background(Color("CherryRed"))
        }
        
        List(0..<4) { item in
            GifImage(gifs[item])
                .frame(width: 200, height: 200)
            
            NavigationLink(destination: gifs_details(), label: {
                Text("Show Details")
            })
        }
    }
}

struct gifs_details: View {
    var body: some View {
        Text("Name: MarioGIF").frame(alignment: .leading).padding(10)
        Text("Type of file: GIF File (.gif)").frame(alignment: .leading).padding(10)
        Text("Opens with: GIFs").frame(alignment: .leading).padding(10)
        Text("File Size: 140KB").frame(alignment: .leading).padding(10)
        Text("Location: Downloads").frame(alignment: .leading).padding(10)
    }
}
