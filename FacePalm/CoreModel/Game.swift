//
//  Game.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 04.02.23.
//

import Foundation

struct Game {
    var gameId: String = ""
    var players: [Player] = []
    var rounds: [Round] = []
    var ownerId: Int?
    var status: String = ""
}

extension Game {
    init(response: GameResponse) {
        self.gameId = response.id
        self.players = response.players.map(Player.init(response:))
        self.rounds = response.rounds.map(Round.init(response:))
        self.ownerId = response.ownerId
        self.status = response.status
    }
}
