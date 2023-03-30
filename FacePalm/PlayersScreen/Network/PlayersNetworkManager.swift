//
//  PlayersNetworkManager.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 06.02.23.
//

import Foundation

class PlayersNetworkManager {
    func joinGame(gameId: String, playerName: String) async throws -> (playerId: Int, game: Game) {
        let url = networkEnvironment.url.appendingPathComponents("join_game")
        var request = URLRequest(url: url)

        request.httpMethod = "PUT"
        request.httpBody = JoinGameBody(gameId: gameId, playerName: playerName).data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, urlResponse) = try await URLSession.shared.data(for: request)

        if let httpURLResponse = urlResponse as? HTTPURLResponse {
            if httpURLResponse.statusCode == 409 {
                throw UserAlreadyExistsError()
            }
        }

        let response = try JSONDecoder().decode(JoinGameResponse.self, from: data)
        return (playerId: response.playerId, Game(response: response.game))
    }
    
    func startGame(gameId: String) async throws -> Game {
        let url = networkEnvironment.url.appendingPathComponents("start_game")
        var request = URLRequest(url: url)
        
        request.httpMethod = "PUT"
        request.httpBody = StartGameBody(gameId: gameId).data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, _) = try await URLSession.shared.data(for: request)
        
        let response = try JSONDecoder().decode(GameResponse.self, from: data)
        return Game(response: response)
    }
    
    func becomeReady(playerId: Int, gameId: String) async throws -> Game {
        let url = networkEnvironment.url.appendingPathComponents("become_ready")
        var request = URLRequest(url: url)
        
        request.httpMethod = "PUT"
        request.httpBody = BecomeReadyBody(playerId: playerId, gameId: gameId).data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, _) = try await URLSession.shared.data(for: request)
        
        let response = try JSONDecoder().decode(GameResponse.self, from: data)
        return Game(response: response)
    }
}
