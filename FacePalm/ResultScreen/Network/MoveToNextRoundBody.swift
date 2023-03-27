//
//  MoveToNextRoundBody.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 27.02.23.
//

import Foundation

struct MoveToNextRoundBody: Encodable {
    let gameId: String
    
    enum CodingKeys: String, CodingKey {
        case gameId = "game_id"
    }
    
    var data: Data? {
        try? JSONEncoder().encode(self)
    }
}
