//
//  SongsList.swift
//  vapor-ios
//
//  Created by Fernando Marins on 13/12/21.
//

import SwiftUI

struct SongsList: View {
    
    @StateObject var viewModel = SongListViewModel()
    
    @State var modal: ModalType? = nil
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.songs) {
                    song in
                    Button {
                        modal = .update(song)
                    } label: {
                        Text(song.title)
                            .font(.title3)
                            .foregroundColor(Color(.label))
                    }
                }.onDelete(perform: viewModel.delete)
            }
            .navigationTitle(Text("🎶 Songs"))
            .toolbar {
                Button {
                    modal = .add
                } label: {
                    Label("Add Songs", systemImage: "plus.circle")
                }
            }
        }
        .sheet(item: $modal, onDismiss: {
            Task {
                do {
                    try await viewModel.fetchSongs()
                } catch {
                    print(error)
                }
            }
        }) { modal in
            switch modal {
            case .add:
                AddUpdateSong(viewModel: AddUpdateSongViewModel())
            case .update(let song):
                AddUpdateSong(viewModel: AddUpdateSongViewModel(currentSong: song))
            }
        }
        .onAppear {
            Task {
                do {
                    try await viewModel.fetchSongs()
                } catch {
                    print(error)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SongsList()
    }
}
