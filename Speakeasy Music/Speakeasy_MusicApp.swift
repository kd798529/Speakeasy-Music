//
//  Speakeasy_MusicApp.swift
//  Speakeasy Music
//
//  Created by Kwaku Dapaah on 8/29/22.
//

import SwiftUI
import Firebase


@main
struct Speakeasy_MusicApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
//            PlayerBarView(content: SongsListView()).tag(0).tabItem { Label("", systemImage: "music.note") }
//            PlayerBarView(content: SearchView()).tag(0).tabItem { Label("", systemImage: "magnifyingglass") }
            TabView {
                PlayerBarView(content: SongsListView()).tag(0).tabItem { Label("", systemImage: "music.note") }
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                PlayerBarView(content: SearchView()).tag(0).tabItem { Label("", systemImage: "magnifyingglass") }
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
