//
//  Album.swift
//  Lastly
//
//  Created by Carl Peto on 12/09/2020.
//  Copyright © 2020 Carl Peto. All rights reserved.
//

import Foundation

struct Album: Decodable {
    var name: String
    var artist: String
    var url: String
    var art: [AlbumImage]
    var mbid: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case artist
        case url
        case art = "image"
        case mbid
    }
}

struct AlbumImage: Decodable {
    enum Size: String, Decodable {
        case small
        case medium
        case large
        case extralarge
    }
    
    var url: String
    var size: Size
    
    enum CodingKeys: String, CodingKey {
        case url = "#text"
        case size
    }
}

// using api documented at https://www.last.fm/api/show/album.search
// sample json can be retrieved from
// curl "http://ws.audioscrobbler.com/2.0/?method=album.search&album=believe&api_key=cec17d8b1fb7c3eed6c63ac255cde1b5&format=json"

extension Album {
    init?(albumJsonData data: Data) {
        let decoder = JSONDecoder()
        do {
            self = try decoder.decode(Album.self, from: data)
        } catch let error {
            print("could not decode album \(error)")
            return nil
        }
    }
    
    static func albums(forJsonData data: Data) -> [Album] {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode([Album].self, from: data)
        } catch let error {
            print("could not decode albums \(error)")
            return []
        }
    }
}
