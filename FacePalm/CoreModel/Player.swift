//
//  Player.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 02.02.23.
//

import Foundation

struct Player: Identifiable, Equatable {
    let id: Int
    let name: String
    let isReady: Bool
    let cards: [Card]
}

extension Player {
    init(response: PlayerResponse) {
        self.id = response.id
        self.name = response.name
        self.isReady = response.isReady
        self.cards = response.cards.map(Card.init(response:))
    }
}
