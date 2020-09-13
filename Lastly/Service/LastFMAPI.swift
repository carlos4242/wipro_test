//
//  API.swift
//  Lastly
//
//  Created by Carl Peto on 11/09/2020.
//  Copyright © 2020 Carl Peto. All rights reserved.
//

import Foundation
import Combine

extension LastFMAPI {
    enum APIErrors: Error {
        case invalidProtocol
        case albumResultsNotFound
    }

    static func getAlbumData(data: Data?) throws -> [Album] {
        
    }
}

struct LastFMAPI {
    enum LastResponseStatus {
        case noSearchRun
        case good
        case error(Error)
        case serverError(Int)
        case misformatted(Error)
    }

    let results = CurrentValueSubject<[Album], Never>([])
    let status = CurrentValueSubject<LastResponseStatus, Never>(.noSearchRun)

    func search(byAlbumName albumName: String) {
        guard let sanitisedAlbumName = albumName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let searchURL = URL(string: "http://ws.audioscrobbler.com/2.0/?method=album.search&album=\(sanitisedAlbumName)&api_key=cec17d8b1fb7c3eed6c63ac255cde1b5&format=json") else {
            return
        }

        URLSession.shared.dataTask(with: searchURL) { (data, response, error) in
            if let error = error {
                self.status.value = .error(error)
                return
            }

            guard let response = response as? HTTPURLResponse else {
                self.status.value = .error(APIErrors.invalidProtocol)
                return
            }
            
            guard (200..<400).contains(response.statusCode) else {
                self.status.value = .serverError(response.statusCode)
                return
            }
            
            do {
                self.results.value = try LastFMAPI.getAlbumData(data: data)
                self.status.value = .good
            } catch let parseError {
                self.status.value = .misformatted(parseError)
            }
        }
    }
}
