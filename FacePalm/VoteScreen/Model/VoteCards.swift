//
//  VoteCards.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 01.03.23.
//

import Foundation

struct VoteCards {
    private let currentRound: CurrentRound
    private let currentPlayer: CurrentPlayer
    
    var cardsToDisplay: [Card] {
        currentRound.round?.chosenCards.filter{ card in !currentPlayer.playerCards.contains(card) } ?? []
    }
    
    init(currentRound: CurrentRound, currentPlayer: CurrentPlayer) {
        self.currentRound = currentRound
        self.currentPlayer = currentPlayer
    }
}
