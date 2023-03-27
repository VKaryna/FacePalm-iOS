//
//  JoinGameResponse.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 17.02.23.
//

import Foundation

struct JoinGameResponse: Decodable {
    let playerId: Int
    let game: GameResponse
    
    enum CodingKeys: String, CodingKey {
        case playerId = "player_id"
        case game
    }
}

