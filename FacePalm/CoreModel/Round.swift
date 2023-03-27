//
//  Round.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 05.02.23.
//

import Foundation

struct Round {
    let id: Int
    let meme: String
    var chosenCards: [Card] = []
    var votedCards: [Card] = []
    var roundWinners: [Int] = []
}

extension Round {
    init(response: RoundResponse) {
        self.id = response.id
        self.meme = response.meme
        self.chosenCards = response.chosenCards.map(Card.init(response:))
        self.roundWinners = response.roundWinners
    }
}
