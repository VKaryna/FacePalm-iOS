//
//  GameNotifications.swift
//  FacePalm
//
//  Created by Pavel Vaitsikhouski on 07.04.23.
//

import SwiftUI

@MainActor
final class GameNotifications: ObservableObject {
    
    // MARK: - Properties
    
    private let subscriptionManager = RealTimeGameManager()
    
    // MARK: - Outputs
    
    @Published var game: Game
    
    // MARK: - Inits
    
    init(gameId: String) {
        _game = Published(wrappedValue: Game(gameId: gameId))
    }
    
    // MARK: - Intents
    
    func subscribeToGameUpdates(attempt: Int = 0) {
        subscriptionManager.establishConnection(gameId: game.gameId) { [weak self] result in
            switch result {
            case .success(let game):
                self?.game = game
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
}
