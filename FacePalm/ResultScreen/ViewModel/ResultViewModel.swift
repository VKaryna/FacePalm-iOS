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
    @Published var showGameScreen: Bool = false
    @Published var showHomeScreen: Bool = false
    @Published var activityIndicator = true

    private let manager = ResultNetworkManager()
    private let subscriptionManager = RealTimeGameManager()
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
    
    func checkMovingToTheNextScreen() {
        if gameState.isInProgress {
            showGameScreen = true
        }
    }
    
    func unsubscribeFromGameUpdates() {
        subscriptionManager.disconnect()
    }
    
    func getTotalPoints(for playerId: Int) -> Int {
        CurrentPlayer(playerId: playerId, players: game.players, rounds: game.rounds).totalPoints
    }
}
