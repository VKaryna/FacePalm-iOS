//
//  GameViewModel.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 22.01.23.
//

import Foundation
import SwiftUI

// Asks to do, does nothing itself

@MainActor
class GameViewModel: ObservableObject {
    @Published var showVoteScreen: Bool = false
    @Published var selectedCardIndex: Int = 0
    @Published var game: Game
    @Published var activityIndicator: Bool = true
    
    private let manager = GameNetworkManager()
    private let subscriptionManager = RealTimeGameManager()
    
    private var gameState: GameState {
        GameState(game: game)
    }
    
    var checkPlayersReadiness: CheckPlayersReadiness {
        CheckPlayersReadiness(players: game.players)
    }
    
    var currentPlayer: CurrentPlayer {
        CurrentPlayer(playerId: playerId, players: game.players, rounds: game.rounds)
    }
    
    var currentRound: CurrentRound {
        CurrentRound(rounds: game.rounds, players: game.players)
    }
    
    var playerId = 0
    
    init(gameId: String, playerId: Int) {
        self.playerId = playerId
        _game = Published(initialValue: Game(gameId: gameId))
    }
    
    func findGame() async throws {
        activityIndicator = true
        game = try await manager.findGame(gameId: game.gameId)
        activityIndicator = false
    }
    
    func chooseCard(cardId: Int) async throws {
        if let roundId = currentRound.round?.id {
            game = try await manager.chooseCard(cardId: cardId, playerId: playerId, roundId: roundId, gameId: game.gameId)
        }
    }
    
    func subscribeToGameUpdates(attempt: Int = 0) {
        subscriptionManager.establishConnection(gameId: game.gameId) { [weak self] result in
            switch result {
            case .success(let game):
                self?.game = game
                self?.checkMovingToTheNextScreen()
            case .failure where attempt < 3:
                self?.unsubscribeFromGameUpdates()
                self?.subscribeToGameUpdates(attempt: attempt + 1)
            case .failure:
                self?.unsubscribeFromGameUpdates()
            }
        }
    }
    
    func unsubscribeFromGameUpdates() {
        subscriptionManager.disconnect()
    }
    
    func checkMovingToTheNextScreen() {
        if gameState.isVoting {
            showVoteScreen = true
        }
    }
}
