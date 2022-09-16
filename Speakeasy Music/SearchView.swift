//
//  SearchView.swift
//  Speakeasy Music
//
//  Created by Kwaku Dapaah on 9/7/22.
//

import SwiftUI

struct SearchView: View {
    
    @ObservedObject var songList = ViewModel()
    
    @State var songSearched: String = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(searchResuslts) { listedSong in
                    NavigationLink (destination: PlayerView(isPlaying: true, song: listedSong, songs: songList.songs, picture: listedSong.image)){
                        HStack {
                            SongImageView(imgURL: listedSong.image, picWidth: 50, picHeight: 50)
                            Text(listedSong.name)
                                .font(.custom("courier", size: 14))
                        }
                    }
                }
            }
            .searchable(text: $songSearched)
            .navigationTitle("Search Song")
            
        }
    }
    
    
    var searchResuslts: [Song] {
        if songSearched.count == 0 {
            return songList.songs
        } else {
            return songList.songs.filter { item in
                item.name.contains(songSearched.lowercased())
            }
        }
    }
    
    init() {
        songList.getSongs()
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
