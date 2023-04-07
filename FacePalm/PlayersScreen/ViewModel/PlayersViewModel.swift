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
    
    func startGame() async throws {
        game = try await manager.startGame(gameId: game.gameId)
    }
    
    func joinGame(playerName: String) async throws {
        let result = try await manager.joinGame(gameId: game.gameId, playerName: playerName)
        game = result.game
        playerId = result.playerId
    }
    
    func becomeReady() async throws {
        game = try await manager.becomeReady(playerId: playerId, gameId: game.gameId)
    }
    
    func checkGameStart() {
        if gameState.isInProgress {
            showGameScreen = true
        }
    }
    
    func onGameNotification(_ game: Game) {
        self.game = game
        checkGameStart()
    }
}
