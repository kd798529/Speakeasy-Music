//
//  SongsListView.swift
//  Speakeasy Music
//
//  Created by Kwaku Dapaah on 8/29/22.
//

import SwiftUI
import FirebaseStorage

struct SongsListView: View {
    @ObservedObject var songList = ViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(songList.songs) {
                    listedSong in
                    //                    NavigationLink(destination: PlayerView(isPlaying: true, song: listedSong, songs: songList.songs, picture: listedSong.image)) {
                    //                        HStack{
                    //                            SongImageView(imgURL: listedSong.image, picWidth: 50, picHeight: 50)
                    //                            Text(listedSong.name)
                    //                        }
                    //                    }
                    HStack{
                        
                        Button(action: {
                            songList.song = listedSong
                            songList.playSong()
                        }) {
                            HStack {
                                
                                SongImageView(imgURL: listedSong.image, picWidth: 50, picHeight: 50)
                                
                                Text(listedSong.name)
                                    .font(.custom("courier", size: 20))
                                    .foregroundColor(.black)
                            }                        }
                    }
                }
            }
            .navigationTitle("Welcome!")
            
        }
    }
    
    init() {
        songList.getSongs()
    }
    
}


struct SongsListView_Previews: PreviewProvider {
    static var previews: some View {
        SongsListView()
    }
}
