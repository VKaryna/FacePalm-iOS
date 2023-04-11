//
//  GameNotifications.swift
//  FacePalm
//
//  Created by Pavel Vaitsikhouski on 07.04.23.
//

import SwiftUI
import Combine

@MainActor
final class GameNotifications: ObservableObject {
    
    // MARK: - Properties
    
    private let subscriptionManager = RealTimeGameManager()
    private let gamePublisher = SingleSubscriberSubject<Game, Never>()
    private let gameStatePublisher = PassthroughSubject<GameState, Never>()
    private(set) var subscribedGameId: String?
    private(set) var currentPlayerId: Int?
    
    // MARK: - Outputs
    
    var game: AnyPublisher<Game, Never> {
        gamePublisher.eraseToAnyPublisher()
    }
    
    var gameState: AnyPublisher<GameState, Never> {
        gameStatePublisher
            .eraseToAnyPublisher()
    }
    
    // MARK: - Intents
    
    func subscribeToGameUpdates(gameId: String, playerId: Int, attempt: Int = 0) {
        subscribedGameId = gameId
        currentPlayerId = playerId
        subscriptionManager.establishConnection(gameId: gameId) { [weak self] result in
            switch result {
            case .success(let game):
                self?.gamePublisher.send(game)
                self?.gameStatePublisher.send(GameState(game: game))
            case .failure where attempt < 3:
                self?.unsubscribeFromGameUpdates()
                self?.subscribeToGameUpdates(gameId: gameId, playerId: playerId, attempt: attempt + 1)
            case .failure:
                self?.unsubscribeFromGameUpdates()
            }
        }
    }
    
    func unsubscribeFromGameUpdates() {
        subscribedGameId = nil
        subscriptionManager.disconnect()
    }
}
