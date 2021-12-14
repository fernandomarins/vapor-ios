//
//  AddUpdateSongViewModel.swift
//  vapor-ios
//
//  Created by Fernando Marins on 14/12/21.
//

import Foundation

final class AddUpdateSongViewModel: ObservableObject {
    
    @Published var songTitle = ""
    
    var songID: UUID?
    
    var isUpdating: Bool {
        // if there's a songID then this variable will be true, which means we will update the song
        songID != nil
    }
    
    var buttonTitle: String {
        songID != nil ? "Update Song" : "Add Song"
    }
    
    var textDescription: String {
        songID != nil ? "Update the name of your song ✨" : "Add a song to your list! 😍"
    }
    
    // if we are creating a new song, then we can use a blank initializer
    init() { }
    
    // otherwise, we will get the title and id to update
    init(currentSong: Song) {
        self.songTitle = currentSong.title
        self.songID = currentSong.id
    }
    
    func addUpdateAction(completion: @escaping () -> Void) {
        Task {
            do {
                if isUpdating {
                    try await updateSong()
                } else {
                    try await addSong()
                }
            } catch {
                print(error)
            }
            completion()
        }
    }
    
    func addSong() async throws {
        // Creating the URL
        let urlString = Constants.baseURL + Endpoints.songs
        
        // Making sure the URL is not nil
        guard let url = URL(string: urlString) else {
            throw HTTPError.badURL
        }
        
        // the song title will be added according to what the user types
        let song = Song(id: nil, title: songTitle)
        
        try await HTTPClient.shared.sendData(to: url, object: song, httpMethod: HTTPMethods.POST.rawValue)
    }
    
    func updateSong() async throws {
        let urlString = Constants.baseURL + Endpoints.songs
        
        guard let url = URL(string: urlString) else {
            throw HTTPError.badURL
        }
        
        let songToUpdate = Song(id: songID, title: songTitle)
        
        try await HTTPClient.shared.sendData(to: url, object: songToUpdate, httpMethod: HTTPMethods.PUT.rawValue)
    }
    
}
