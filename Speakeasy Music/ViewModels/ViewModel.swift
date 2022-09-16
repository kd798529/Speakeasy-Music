//
//  ViewModel.swift
//  Speakeasy Music
//
//  Created by Kwaku Dapaah on 8/29/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftUI
import AVFoundation

class ViewModel: ObservableObject {
    @Published var songs = [Song]()
    @Published var song: Song = Song(id: "", name: "", file: "", image: "")
    @Published var picture: String = ""
    @Published var imageURL: URL?
    
    @Published var isPlaying: Bool = false
    
    @Published var player = AVPlayer()
    
    
    func getSongs() {
        
        // Get a reference to the database
        
        let db = Firestore.firestore()
        // Read the documents at a specific path
        db.collection("Songs").getDocuments { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    
                    //update the list property in the main thread
                    DispatchQueue.main.async {
                        //get all documents and create Songs
                        self.songs = snapshot.documents.map { d in
                            return Song(id: d.documentID, name: d["name"] as? String ??  "", file: d["file"] as? String ?? "", image: d["image"] as? String ?? "")
                        }
                    }
                    
                    
                }
            }
            
        }
        
    }
    
    func downloadSongImage(imageURL: String) {
        
        let pictureFromStorage = Storage.storage().reference(forURL: imageURL)
        pictureFromStorage.downloadURL { url, error in
            if error != nil {
                print("Unable to retrieve data")
            } else {
                self.imageURL = url
            }
        }
    }
    
    func playSong() {
        let storage = Storage.storage().reference(forURL: song.file)
        
        storage.downloadURL { url, error in
            if error != nil {
                print("Unable to retrieve data")
            } else {
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                } catch {
                    // report for an error
                    print("cant play song!")
                }
                self.player = AVPlayer(url: url!)
                
                
                if self.isPlaying == false {
                    self.togglePlayPause()
                } else {

                    self.player.play()
                }
            }
        }
    }
    
      
    func togglePlayPause() {
        self.isPlaying = !self.isPlaying
        
        if isPlaying == false {
            player.pause()
            print(player.currentTime())
        } else {
            player.play()
            print(player.currentTime())
        }
    }
    
    func nextSong() {
        if let currentindex = songs.firstIndex(of: song) {
            if currentindex == songs.count - 1 {
                
            } else {
                player.pause()
                song = songs[currentindex + 1]
                self.playSong()
                picture = song.image
                self.downloadSongImage(imageURL: picture)
            }
            
        }
        
    }
    
    func previousSong() {
        if let currentindex = songs.firstIndex(of: song) {
            if currentindex == 0 {
                
            }
            else {
                player.pause()
                song = songs[currentindex - 1]
                self.playSong()
                picture = song.image
                self.downloadSongImage(imageURL: picture)
            }
            
        }
    }
}
