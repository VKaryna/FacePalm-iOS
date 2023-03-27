//
//  HomeViewModel.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 05.02.23.
//

import Foundation
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    
    // MARK: - Properties
    
    private let manager = HomeNetworkManager()
    
    // MARK: - Outputs
    
    @Published var gameId: String = ""
    
    // MARK: - Intents
    
    func createGame() async throws {
        let game = try await manager.createGame()
        gameId = "\(game.gameId)"
    }
    
    func findGame() async throws {
        let game = try await manager.findGame(gameId: gameId)
        gameId = "\(game.gameId)"
    }
}
