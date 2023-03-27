//
//  StartGameBody.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 05.02.23.
//

import Foundation

struct StartGameBody: Encodable {
    let gameId: String
    
    enum CodingKeys: String, CodingKey {
        case gameId = "game_id"
    }
    
    var data: Data? {
        try? JSONEncoder().encode(self)
    }
}
