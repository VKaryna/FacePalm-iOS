//
//  VoteViewModel.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 09.02.23.
//

import Foundation

@MainActor
class VoteViewModel: ObservableObject {
    private let manager = VoteNetworkManager()
    var playerId = 0

    @Published var selectedCardIndex: Int = 0
    @Published var game: Game
    @Published var activityIndicator = true
    
    var checkPlayersReadiness: CheckPlayersReadiness {
        CheckPlayersReadiness(players: game.players)
    }
    
    var currentPlayer: CurrentPlayer {
        CurrentPlayer(playerId: playerId, players: game.players, rounds: game.rounds)
    }
    
    var currentRound: CurrentRound {
        CurrentRound(rounds: game.rounds, players: game.players)
    }
    
    var voteCards: VoteCards {
        VoteCards(currentRound: currentRound, currentPlayer: currentPlayer)
    }
    
    init(gameId: String, playerId: Int) {
        self.playerId = playerId
        _game = Published(initialValue: Game(gameId: gameId))
    }
    
    func findGame() async throws {
        activityIndicator = true
        game = try await manager.findGame(gameId: game.gameId)
        activityIndicator = false
    }
    
    func voteCard(cardId: Int) async throws {
        if let roundId = currentRound.round?.id {
            let game = try await manager.voteCard(cardId: cardId, playerId: playerId, roundId: roundId, gameId: game.gameId)
            onGameNotification(game)
        }
    }
    
    func onGameNotification(_ game: Game) {
        if GameState(game: game) == .vote {
            self.game = game
        }
    }
}
