//
//  Players.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 10.02.23.
//

import Foundation

struct SortedPlayers {
    private let players: [Player]
    private let rounds: [Round]

    var sortedPlayers: [Player] {
        players.sorted(by: {
            lhs, rhs in
            CurrentPlayer(playerId: lhs.id, players: players, rounds: rounds).totalPoints > CurrentPlayer(playerId: rhs.id, players: players, rounds: rounds).totalPoints
        })
    }
    
    init(players: [Player], rounds: [Round]) {
        self.players = players
            self.rounds = rounds
    }
}
