//
//  JoinGameBody.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 02.02.23.
//

import Foundation

struct JoinGameBody: Encodable {
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
