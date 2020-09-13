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

extension Album {
    static func getAlbumData(data: Data?) throws -> [Album] {
        guard
            let data = data,
            let dictionaryFromJSON = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any],
            let results = dictionaryFromJSON["results"] as? [String:Any],
            let albummatches = results["albummatches"] as? [String:Any],
            let albums = albummatches["album"] as? [[String:Any]]
            else {
            return []
        }

        guard let jsonData = try? JSONSerialization.data(withJSONObject: albums, options: []) else {
            return []
        }

        return Album.albums(forJsonData: jsonData)
    }
}

let responseJson = """
{
    "results": {
        "opensearch:Query": {
            "#text": "",
            "role": "request",
            "searchTerms": "believe",
            "startPage": "1"
        },
        "opensearch:totalResults": "127013",
        "opensearch:startIndex": "0",
        "opensearch:itemsPerPage": "50",
        "albummatches": {
            "album": [
                {
                    "name": "Believe",
                    "artist": "Disturbed",
                    "url": "https://www.last.fm/music/Disturbed/Believe",
                    "image": [
                        {
                            "#text": "https://lastfm.freetls.fastly.net/i/u/34s/bca3b80481394e25b03f4fc77c338897.png",
                            "size": "small"
                        },
                        {
                            "#text": "https://lastfm.freetls.fastly.net/i/u/64s/bca3b80481394e25b03f4fc77c338897.png",
                            "size": "medium"
                        },
                        {
                            "#text": "https://lastfm.freetls.fastly.net/i/u/174s/bca3b80481394e25b03f4fc77c338897.png",
                            "size": "large"
                        },
                        {
                            "#text": "https://lastfm.freetls.fastly.net/i/u/300x300/bca3b80481394e25b03f4fc77c338897.png",
                            "size": "extralarge"
                        }
                    ],
                    "streamable": "0",
                    "mbid": "c559efc2-f734-41ae-93bd-2d78414e0356"
                },
                {
                    "name": "Make Believe",
                    "artist": "Weezer",
                    "url": "https://www.last.fm/music/Weezer/Make+Believe",
                    "image": [
                        {
                            "#text": "https://lastfm.freetls.fastly.net/i/u/34s/1c8439b16ed4ca4e0bac727e7b325581.png",
                            "size": "small"
                        },
                        {
                            "#text": "https://lastfm.freetls.fastly.net/i/u/64s/1c8439b16ed4ca4e0bac727e7b325581.png",
                            "size": "medium"
                        },
                        {
                            "#text": "https://lastfm.freetls.fastly.net/i/u/174s/1c8439b16ed4ca4e0bac727e7b325581.png",
                            "size": "large"
                        },
                        {
                            "#text": "https://lastfm.freetls.fastly.net/i/u/300x300/1c8439b16ed4ca4e0bac727e7b325581.png",
                            "size": "extralarge"
                        }
                    ],
                    "streamable": "0",
                    "mbid": "9e7103bb-fc9a-4e5a-a90c-2a3ab4c08e19"
                }
            ]
        },
        "@attr": {
            "for": "believe"
        }
    }
}
"""

let data = responseJson.data(using: .utf8)!

let al = Album.getAlbumData(data: data)

//let data = data
let dictionaryFromJSON = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
let results = dictionaryFromJSON["results"] as! [String:Any]
let albummatches = results["albummatches"] as! [String:Any]
let albums = albummatches["album"] as! [[String:Any]]

albums[0]


guard let jsonData = try? JSONSerialization.data(withJSONObject: albums, options: []) else {
    fatalError()
}

let albumsDecoded = Album.albums(forJsonData: jsonData)

albumsDecoded[0]
albumsDecoded.count

