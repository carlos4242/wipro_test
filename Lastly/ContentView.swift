//
//  ContentView.swift
//  Lastly
//
//  Created by Carl Peto on 11/09/2020.
//  Copyright © 2020 Carl Peto. All rights reserved.
//

import SwiftUI

struct AlbumView: View {
    let album: Album

    var body: some View {
        VStack {
            HStack {
                Text("Album:")
                Text(album.name)
            }
            HStack {
                Text("Artist:")
                Text(album.artist)
            }
            Divider()
        }
    }
}

struct LastFMSearchView: View {
    @ObservedObject var searchResults: LastFMAPI

    var body: some View {
        VStack {
            Text("Enter album name:")
            TextField("Enter album name:", text: $searchResults.searchText)
            Divider()
            List(searchResults.results) { album in
                AlbumView(album: album)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let demoAlbums: [Album] = [Album(name: "demo1", artist: "test", url: "", art: [], mbid: "test1")]
        let search = LastFMAPI(initialResults: demoAlbums)
        return LastFMSearchView(searchResults: search)
    }
}
