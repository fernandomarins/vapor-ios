//
//  SongListViewModel.swift
//  vapor-ios
//
//  Created by Fernando Marins on 13/12/21.
//

import SwiftUI

class SongListViewModel: ObservableObject {
    @Published var songs = [Song]()
    
    func fetchSongs() async throws {
        // Creating the URL
        let urlString = Constants.baseURL + Endpoints.songs
        
        // Making sure the URL is not nil
        guard let url = URL(string: urlString) else {
            throw HTTPError.badURL
        }
        
        // Creating a response
        // Since we declared a return type of T for fetch, we need to specify that
        // songResponse will be an array of Song
        let songResponse: [Song] = try await HTTPClient.shared.fetch(url: url)
        DispatchQueue.main.async {
            self.songs = songResponse
        }
    }
    
    func delete(at offSets: IndexSet) {
        offSets.forEach { i in
            guard let songID = songs[i].id else {
                return
            }
            
            guard let url = URL(string: Constants.baseURL + Endpoints.songs + "/\(songID)") else {
                return
            }
            print(url)
            
            Task {
                do {
                    try await HTTPClient.shared.delete(at: songID, url: url)
                } catch {
                    print(error)
                }
            }
        }
        
        songs.remove(atOffsets: offSets)
        
    }
}
