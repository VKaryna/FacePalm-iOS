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
    var playerName: String? {
        game.players.first(where: { $0.id == playerId })?.name
    }

    @Published var game: Game

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
    
    func leaveGame() async throws {
        guard let playerName = playerName else { return }
        _ = try await manager.leaveGame(gameId: game.gameId, playerName: playerName)
    }
    
    func becomeReady() async throws {
        game = try await manager.becomeReady(playerId: playerId, gameId: game.gameId)
    }
    
    func onGameNotification(_ game: Game) {
        self.game = game
    }
}
