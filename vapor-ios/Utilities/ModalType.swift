//
//  ModalType.swift
//  vapor-ios
//
//  Created by Fernando Marins on 14/12/21.
//

import Foundation

enum ModalType: Identifiable {
    var id: String {
        switch self {
        case .add: return "add"
        case .update: return "update"
        }
    }
    
    case add
    case update(Song)
}
