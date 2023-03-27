//
//  VoteCardBody.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 09.02.23.
//

import Foundation

struct VoteCardBody: Encodable {
    let cardId: Int
    let playerId: Int
    let roundId: Int
    let gameId: String
   
   enum CodingKeys: String, CodingKey {
       case cardId = "card_id"
       case playerId = "player_id"
       case roundId = "round_id"
       case gameId = "game_id"
   }
   
   var data: Data? {
       try? JSONEncoder().encode(self)
   }
}
