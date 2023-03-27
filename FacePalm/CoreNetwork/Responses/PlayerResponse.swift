//
//  PlayerResponse.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 04.02.23.
//

import Foundation

struct PlayerResponse: Decodable {
    let id: Int
    let name: String
    let isReady: Bool
    let cards: [CardResponse]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case isReady = "is_ready"
        case cards
    }
}
