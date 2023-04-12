//
//  ResultViewModel.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 10.02.23.
//

import Foundation

@MainActor
class ResultViewModel: ObservableObject {
    @Published var game: Game
    @Published var activityIndicator = true

    private let manager = ResultNetworkManager()
    var playerId = 0
    
    private var gameState: GameState {
        GameState(game: game)
    }
    
    var gameWinners: [Player] {
        var highestScore = -1
        if let winnerId = sortedPlayers.first?.id {
            highestScore = getTotalPoints(for: winnerId)
        }
        return sortedPlayers.filter { player in getTotalPoints(for: player.id) == highestScore }
    }
    
    var currentRound: CurrentRound {
        CurrentRound(rounds: game.rounds, players: game.players)
    }
    
    var sortedPlayers: [Player] {
        SortedPlayers(players: game.players, rounds: game.rounds).sortedPlayers
    }
    
    var isTheLastRound: Bool {
        currentRound.round == nil
    }
    
    var shouldShowContinueButton: Bool {
        isCurrentPlayerOwner || isTheLastRound
    }
    
    var isCurrentPlayerOwner: Bool {
        playerId == game.ownerId && game.ownerId != nil
    }
    
    init(gameId: String, playerId: Int) {
        self.playerId = playerId
        _game = Published(wrappedValue: Game(gameId: gameId))
    }
    
    func findGame() async throws {
        activityIndicator = true
        game = try await manager.findGame(gameId: game.gameId)
        activityIndicator = false
    }
    
    func moveToNextRound() async throws {
        game = try await manager.moveToNextRound(gameId: game.gameId)
    }
    
    func getTotalPoints(for playerId: Int) -> Int {
        CurrentPlayer(playerId: playerId, players: game.players, rounds: game.rounds).totalPoints
    }
    
    func onGameNotifications(_ game: Game) {
        if GameState(game: game) == .results {
            self.game = game
        }
    }
}
