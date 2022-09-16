//
//  PlayerView.swift
//  Speakeasy Music
//
//  Created by Kwaku Dapaah on 8/30/22.
//

import SwiftUI
import FirebaseStorage
import AVFoundation

struct PlayerView: View {
    
    @State var isPlaying: Bool = false
    
    @State var song: Song
    var songs: [Song] = []
    
    @State var player = AVPlayer()
    
    @State var sliderValue: Double = 0.00
    
    @State var durationSong: Double = 0.00
    
    @State var currentTime: String = "00:00"
    
    @State var picture: String
    
    @ObservedObject var songList = ViewModel()
    
    
    var body: some View {
        VStack {

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
            
                        
                        
            Text(song.name)
                .padding()

            VStack {
                
                Slider(value: $sliderValue, onEditingChanged: { changed in
                    if changed {
                        print("changed slider value is: \(sliderValue)")
                        //seekToTime(seekSliderValue: sliderValue)
                    } 
                })
                    .padding()
                Text(currentTime)
            }
            HStack {
                Spacer()
                Button(action: {previousSong()}, label: {
                    Image(systemName: "backward.end.fill")
                        .resizable()
                }).frame(width: 30, height: 30, alignment: .center
                )
                Spacer()
                Button(action: {togglePlayPause()}, label: {
                    Image(systemName: isPlaying ?  "pause.fill" :"play.fill"  )
                        .resizable()
                }).frame(width: 50, height: 50, alignment: .center)
                Spacer()
                Button(action: {nextSong()}, label: {
                    Image(systemName: "forward.end.fill")
                        .resizable()
                }).frame(width: 30, height: 30, alignment: .center)
                Spacer()
            }
            Spacer()
        }.onAppear() {
            self.playSong()
            songList.downloadSongImage(imageURL: picture)
        }
    }
    
    func playSong() {
        let storage = Storage.storage().reference(forURL: self.song.file)
        storage.downloadURL { url, error in
            if error != nil {
                print("Unable to retrieve data")
            } else {
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                } catch {
                    // report for an error
                }
                player = AVPlayer(url: url!)
                
                
                if isPlaying == false {
                    togglePlayPause()
                } else {

                    player.play()
                }
                
                
                if let songDuration = player.currentItem?.duration.seconds {
                    durationSong = songDuration
                }
                
                
                
                //track player progress
                
                let interval = CMTime(value: 1, timescale: 2)

                
                player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { progressTime in
                    let seconds = CMTimeGetSeconds(progressTime)
                    //print(seconds)
                    let secondsString = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
                    let minuteString = String(format: "%02d", Int(seconds / 60))
                    
                    self.currentTime = "\(minuteString):\(secondsString)"
                    
                    if let duration = player.currentItem?.duration {
                        let durationSeconds = CMTimeGetSeconds(duration)
                        
                        self.sliderValue = seconds / durationSeconds
                        self.durationSong = durationSeconds
                    }
                    
                }
                
            }
        }
    }
    
    func seekToTime(seekSliderValue: Double) {
        
        if let currentSong = player.currentItem {
            let sec = CMTimeGetSeconds(currentSong.duration)  * seekSliderValue
            print("this is seek sec: \(sec)")
            let secCMT = CMTimeMake(value: Int64(sec), timescale: 1000)
            player.seek(to: secCMT, completionHandler: {_ in
                sliderValue = CMTimeGetSeconds(secCMT)
                print(player.currentTime())
                player.playImmediately(atRate: 1)
            })
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
                songList.downloadSongImage(imageURL: picture)
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
                songList.downloadSongImage(imageURL: picture)
            }
            
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(song: Song(id: "1", name: "1", file: "1", image: "1"), durationSong: 0.00, picture: "")
    }
}
