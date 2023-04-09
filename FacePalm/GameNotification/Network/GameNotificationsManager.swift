//
//  GameNotificationsManager.swift
//  FacePalm
//
//  Created by Pavel Vaitsikhouski on 07.04.23.
//

import Foundation

final class GameNotificationsManager {
    
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
}
