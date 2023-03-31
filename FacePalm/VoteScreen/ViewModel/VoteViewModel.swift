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
    private let subscriptionManager = RealTimeGameManager()
    var playerId = 0

    @Published var showResultScreen: Bool = false
    @Published var selectedCardIndex: Int = 0
    @Published var game: Game
    @Published var activityIndicator = true
    
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
        subscribeToGameUpdates()
    }
    
    func voteCard(cardId: Int) async throws {
        if let roundId = currentRound.round?.id {
            game = try await manager.voteCard(cardId: cardId, playerId: playerId, roundId: roundId, gameId: game.gameId)
        }
    }
    
    func subscribeToGameUpdates(attempt: Int = 0) {
        subscriptionManager.establishConnection(gameId: game.gameId) { [weak self] result in
            switch result {
            case .success(let game):
                self?.game = game
                self?.checkRoundEnd()
            case .failure where attempt < 3:
                self?.unsubscribeFromGameUpdates()
                self?.subscribeToGameUpdates(attempt: attempt + 1)
            case .failure:
                self?.unsubscribeFromGameUpdates()
            }
        }
    }
    
    func checkRoundEnd() {
        if gameState.isResults {
            showResultScreen = true
        }
    }
    
    func unsubscribeFromGameUpdates() {
        subscriptionManager.disconnect()
    }
}
