//
//  Song.swift
//  vapor-ios
//
//  Created by Fernando Marins on 13/12/21.
//

import Foundation

struct Song: Identifiable, Codable {
    let id: UUID?
    var title: String
}
