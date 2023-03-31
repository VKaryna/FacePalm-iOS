//
//  CurrentPlayer.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 05.02.23.
//

import Foundation

struct CurrentPlayer {
    private let playerId: Int
    private let players: [Player]
    private let rounds: [Round]
    
    var player: Player? {
        players.filter { player in player.id == playerId }.first
    }
    
    var cardsToDisplay: [Card] {
        player?.cards.filter { card in !chosenCards.contains(card) } ?? []
    }
    
    var playerCards: [Card] {
        player?.cards ?? []
    }
    
    var chosenCards: [Card] {
        rounds.flatMap { round in round.chosenCards }
    }
    
    var totalPoints: Int {
        rounds.filter { round in round.roundWinners.contains(playerId) }.count
    }
    
    init(playerId: Int, players: [Player], rounds: [Round]) {
        self.playerId = playerId
        self.players = players
        self.rounds = rounds
    }
}
