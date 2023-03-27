//
//  CurrentRound.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 21.02.23.
//

import Foundation

struct CurrentRound {
    private let rounds: [Round]
    private let players: [Player]
    
    var round: Round? {
        rounds.filter { round in round.roundWinners.isEmpty }.first
    }
    
    var latestFinishedRound: Round? {
        rounds.filter { round in !round.roundWinners.isEmpty }.last
    }
    
    var roundNumber: Int {
        (rounds.firstIndex(where: { $0.id == round?.id }) ?? 0) + 1
    }
    
    var winners: [Player] {
        latestFinishedRound != nil ? players.filter { player in latestFinishedRound!.roundWinners.contains(player.id) } : []
    }
    
    init(rounds: [Round], players: [Player]) {
        self.rounds = rounds
        self.players = players
    }
}
