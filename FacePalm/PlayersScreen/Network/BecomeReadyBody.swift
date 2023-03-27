//
//  BecomeReadyBody.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 14.02.23.
//

import Foundation

struct BecomeReadyBody: Encodable {
    let playerId: Int
    let gameId: String
    
    enum CodingKeys: String, CodingKey {
        case playerId = "player_id"
        case gameId = "game_id"
    }
    
    var data: Data? {
        try? JSONEncoder().encode(self)
    }
}
