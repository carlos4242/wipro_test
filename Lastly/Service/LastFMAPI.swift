//
//  API.swift
//  Lastly
//
//  Created by Carl Peto on 11/09/2020.
//  Copyright © 2020 Carl Peto. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class LastFMAPI: ObservableObject {
    enum APIErrors: Error {
        case invalidProtocol
        case albumResultsNotFound
    }

    enum LastResponseStatus {
        case noSearchRun
        case good
        case error(Error)
        case serverError(Int)
        case misformatted(Error)
    }

    init(initialResults: [Album] = []) {
        results = initialResults
    }

    @Published var results: [Album]
    @Published var status: LastResponseStatus = .noSearchRun

    @Published var searchText: String = "" {
        didSet {
            searchTextChanged.send(searchText)
        }
    }

    private let searchTextChanged = PassthroughSubject<String, Never>()
    var searchTextDebounced: AnyPublisher<String, Never> {
        searchTextChanged
            .debounce(for: .seconds(0.9), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }

    var monitorSearchText: AnyCancellable?

    func monitor() {
        monitorSearchText = searchTextDebounced.sink { [weak self] (newSearchText) in
            self?.search(byAlbumName: newSearchText)
        }
    }

    func search(byAlbumName albumName: String) {
        guard !albumName.isEmpty else {
            // the simplest case, clear the search
            self.results = []
            self.status = .good
            return
        }

        guard let sanitisedAlbumName = albumName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let searchURL = URL(string: "http://ws.audioscrobbler.com/2.0/?method=album.search&album=\(sanitisedAlbumName)&api_key=cec17d8b1fb7c3eed6c63ac255cde1b5&format=json") else {
            return
        }

        URLSession.shared.dataTask(with: searchURL) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    print("error: \(error)")
                    self.status = .error(error)
                }
                return
            }

            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    self.status = .error(APIErrors.invalidProtocol)
                }
                return
            }
            
            guard (200..<400).contains(response.statusCode) else {
                DispatchQueue.main.async {
                    self.status = .serverError(response.statusCode)
                }
                return
            }

            let results = Album.getAlbumData(data: data)

            DispatchQueue.main.async {
                self.results = results
                self.status = .good
            }

        }.resume()
    }
}
