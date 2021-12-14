//
//  AddUpdateSong.swift
//  vapor-ios
//
//  Created by Fernando Marins on 14/12/21.
//

import SwiftUI

struct AddUpdateSong: View {
    
    @ObservedObject var viewModel: AddUpdateSongViewModel
    // we create this variable so we can dismiss this view
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text(viewModel.textDescription)
                .fontWeight(.bold)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .padding(.bottom, 50.0)
                .padding(.leading, 10.0)
                .padding(.trailing, 10.0)
            TextField("song title", text: $viewModel.songTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button {
                viewModel.addUpdateAction {
                    presentationMode.wrappedValue.dismiss()
                }
            } label: {
                Text(viewModel.buttonTitle)
            }
            .padding(.top, 10.0)
        }
    }
}

struct AddUpdateSong_Previews: PreviewProvider {
    static var previews: some View {
        AddUpdateSong(viewModel: AddUpdateSongViewModel())
    }
}
