//
//  LastlyTests.swift
//  LastlyTests
//
//  Created by Carl Peto on 12/09/2020.
//  Copyright © 2020 Carl Peto. All rights reserved.
//

import XCTest
@testable import Lastly

class LastlyTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDecoding() throws {
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

        XCTAssert(al.count == 2, "not enough albums")
        XCTAssert(al[0].name == "Believe", "album name fail")
        XCTAssert(al[0].artist == "Disturbed", "album artist fail")
        XCTAssert(al[1].name == "Make Believe", "album name fail")
        XCTAssert(al[1].artist == "Weezer", "album artist fail")
    }
}
