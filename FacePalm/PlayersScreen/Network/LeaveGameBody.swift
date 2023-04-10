//
//  LeaveGameBody.swift
//  FacePalm
//
//  Created by Pavel Vaitsikhouski on 10.04.23.
//

import Foundation

struct LeaveGameBody: Encodable {
    let gameId: String
    let playerName: String
    
    enum CodingKeys: String, CodingKey {
        case gameId = "game_id"
        case playerName = "player_name"
    }
    
    var data: Data? {
        try? JSONEncoder().encode(self)
    }
}
