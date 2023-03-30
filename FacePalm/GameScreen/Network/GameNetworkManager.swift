//
//  GameNetworkManager.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 07.02.23.
//

import Foundation

class GameNetworkManager {
    func findGame(gameId: String) async throws -> Game {
        let url = networkEnvironment.url.appendingPathComponents("find_game", "\(gameId)")
        var request = URLRequest(url: url)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, urlResponse) = try await URLSession.shared.data(for: request)

        if let httpURLResponse = urlResponse as? HTTPURLResponse {
            if httpURLResponse.statusCode == 404 {
                throw GameNotFoundError()
            }
        }

        let response = try JSONDecoder().decode(GameResponse.self, from: data)
        return Game(response: response)
    }
    
    func chooseCard(cardId: Int, playerId: Int, roundId: Int, gameId: String) async throws -> Game {
        let url = networkEnvironment.url.appendingPathComponents("choose_card")
        var request = URLRequest(url: url)
        
        request.httpMethod = "PUT"
        request.httpBody = ChooseCardBody(cardId: cardId, playerId: playerId, roundId: roundId, gameId: gameId).data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let response = try JSONDecoder().decode(GameResponse.self, from: data)
        return Game(response: response)
    }
}
