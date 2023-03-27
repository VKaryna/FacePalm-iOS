//
//  HomeNetworkManager.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 05.02.23.
//

import Foundation

class HomeNetworkManager {
    
    func createGame() async throws -> Game {
        let url = networkEnvironment.url.appendingPathComponents("create_game")
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let response = try JSONDecoder().decode(GameResponse.self, from: data)
        return Game(response: response)
    }
    
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
