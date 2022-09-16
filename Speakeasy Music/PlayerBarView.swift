//
//  PlayerBarView.swift
//  Speakeasy Music
//
//  Created by Kwaku Dapaah on 9/12/22.
//

import SwiftUI
import FirebaseStorage
import AVFoundation

struct PlayerBarView<Content: View>: View {
    var content: Content
    
    @State var isPlaying: Bool = false
    
    @State var song: Song = Song(id: "", name: "", file: "", image: "")
    
    var songs: [Song] = []
    
    @State var player = AVPlayer()
    
    @State var picture: String = ""
    
    @ObservedObject var songList = ViewModel()
    
    @ViewBuilder var body: some View {
        ZStack(alignment: .bottom) {
            content
            
            
            Rectangle().foregroundColor(Color.white.opacity(0.0)).frame(width: UIScreen.main.bounds.size.width, height: 65).background(Blur())
            HStack {
                    Button(action: {}) {
                        HStack {
                            if let url = songList.imageURL {
                                AsyncImage(url: url){ image in
                                    image.resizable()
                                    
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 250, height: 250)
                                .cornerRadius(6)
                                .padding()
                            }
                            Text("Shake It Off").padding(.leading, 10)
                            Spacer()
                        }
                    }.buttonStyle(PlainButtonStyle())
                
                    Button(action: {
                        player.pause()
                        print("play or pause button pressed")
                    }) {
                        Image(systemName: isPlaying ?  "pause.fill" :"play.fill")
                            .font(.title3)
                    }.buttonStyle(PlainButtonStyle()).padding(.horizontal)
                
                    Button(action: {}) {
                        Image(systemName: "forward.fill").font(.title3)
                    }.buttonStyle(PlainButtonStyle()).padding(.trailing, 30)
                }
            
        }
        

    }
}

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemChromeMaterial
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

//struct PlayerBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayerBarView(content: )
//    }
//}
