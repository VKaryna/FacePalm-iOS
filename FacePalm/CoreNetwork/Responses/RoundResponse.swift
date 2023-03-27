//
//  RoundResponse.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 05.02.23.
//

import Foundation

struct RoundResponse: Decodable {
    let id: Int
    let meme: String
    let chosenCards: [CardResponse]
    let votedCards: [CardResponse]
    let roundWinners: [Int]
    
    enum CodingKeys: String, CodingKey {
        case id
        case meme
        case chosenCards = "chosen_cards"
        case votedCards = "voted_cards"
        case roundWinners = "round_winners"
    }
}
