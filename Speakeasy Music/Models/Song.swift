//
//  Song.swift
//  Speakeasy Music
//
//  Created by Kwaku Dapaah on 8/29/22.
//

import Foundation

struct Song: Identifiable, Equatable {
    var id: String
    var name: String
    var file: String
    var image: String
}
