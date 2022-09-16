//
//  SongImageView.swift
//  Speakeasy Music
//
//  Created by Kwaku Dapaah on 9/8/22.
//

import SwiftUI

struct SongImageView: View {
    @ObservedObject var songList = ViewModel()
    @State var imgURL: String = ""
    @State var picWidth: CGFloat = 0
    @State var picHeight: CGFloat = 0
    
    var body: some View {
        
        ZStack{
            if let url = songList.imageURL {   
                AsyncImage(url: url){ image in
                    image.resizable()
                    
                } placeholder: {
                    ProgressView()
                }
                .frame(width: picWidth, height: picHeight)
                .padding()
                
            }
        }.onAppear() {
            songList.downloadSongImage(imageURL: imgURL)
        }
    }
}

struct SongImageView_Previews: PreviewProvider {
    static var previews: some View {
        SongImageView()
    }
}
