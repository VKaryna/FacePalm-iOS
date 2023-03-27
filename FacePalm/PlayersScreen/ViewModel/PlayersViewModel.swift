//
//  PlayersViewModel.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 06.02.23.
//

import Foundation
import SwiftUI

@MainActor
class PlayersViewModel: ObservableObject {
    
    private let manager = PlayersNetworkManager()
    private let subscriptionManager = RealTimeGameManager()
    
    private var gameState: GameState {
        GameState(game: game)
    }
    
    private var playersReadiness: CheckPlayersReadiness {
        CheckPlayersReadiness(players: game.players)
    }
    
    var isAllUsersReady: Bool {
        playersReadiness.isAllReady
    }
    
    var isNotEnoughPlayers: Bool {
        !playersReadiness.isAtLeastThreePlayers
    }
    
    var playerId = 0

    @Published var game: Game
    @Published var showGameScreen: Bool = false

    init(gameId: String) {
        _game = Published(wrappedValue: Game(gameId: gameId))
    }
    
    var shouldShowStartButton: Bool {
        playerId == game.ownerId && game.ownerId != nil
    }
        
    func subscribeToGameUpdates(attempt: Int = 0) {
        subscriptionManager.establishConnection(gameId: game.gameId) { [weak self] result in
            switch result {
            case .success(let game):
                self?.game = game
                self?.checkGameStart()
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
    
    func startGame() async throws {
        game = try await manager.startGame(gameId: game.gameId)
    }
    
    func joinGame(playerName: String) async throws {
        let result = try await manager.joinGame(gameId: game.gameId, playerName: playerName)
        game = result.game
        playerId = result.playerId
        subscribeToGameUpdates()
    }
    
    func becomeReady() async throws {
        game = try await manager.becomeReady(playerId: playerId, gameId: game.gameId)
    }
    
    func checkGameStart() {
        if gameState.isInProgress {
            showGameScreen = true
        }
    }
}
