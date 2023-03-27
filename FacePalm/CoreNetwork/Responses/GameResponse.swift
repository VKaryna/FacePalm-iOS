//
//  CreateGameResponse.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 22.01.23.
//

import Foundation

struct GameResponse: Decodable {
    let id: String
    let players: [PlayerResponse]
    let rounds: [RoundResponse]
    let ownerId: Int?
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case players
        case rounds
        case ownerId = "owner_id"
        case status
    }
}
