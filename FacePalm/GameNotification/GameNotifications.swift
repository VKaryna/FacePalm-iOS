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
    private var subscribedGameId: String?
    
    // MARK: - Outputs
    
    var game: AnyPublisher<Game, Never> {
        gamePublisher.eraseToAnyPublisher()
    }
    
    // MARK: - Intents
    
    func subscribeToGameUpdates(gameId: String, attempt: Int = 0) {
        subscribedGameId = gameId
        subscriptionManager.establishConnection(gameId: gameId) { [weak self] result in
            switch result {
            case .success(let game):
                self?.gamePublisher.send(game)
            case .failure where attempt < 3:
                self?.unsubscribeFromGameUpdates()
                self?.subscribeToGameUpdates(gameId: gameId, attempt: attempt + 1)
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
