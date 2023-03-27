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
        
//        var game = Game()
//        game.rounds = [Round(response: RoundResponse(id: 1, meme: "image1", chosenCards: [], votedCards: [], roundWinners: []))]
//        game.players = [Player(id: 1, name: "Pavel", isReady: true, cards: [Card(id: 1, text: "Meow"), Card(id: 2, text: "Dog"), Card(id: 3, text: "Cat")]), Player(id: 2, name: "Karyna", isReady: false, cards: [Card(id: 1, text: "Meow"), Card(id: 2, text: "Dog"), Card(id: 3, text: "Cat")]), Player(id: 3, name: "Olga", isReady: false, cards: [Card(id: 1, text: "Meow"), Card(id: 2, text: "Dog"), Card(id: 3, text: "Cat")])]
//        return game
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
