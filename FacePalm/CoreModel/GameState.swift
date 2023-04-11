//
//  GameState.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 13.02.23.
//

import Foundation

enum GameState {
    case game, vote, results, finish, home, players
    
    init(game: Game) {
        switch game.status {
        case "CREATED":
            self = .players
        case "ROUND":
            self = .game
        case "VOTING":
            self = .vote
        case "RESULTS":
            self = .results
        case "FINISHED":
            self = .finish
        default:
            self = .home
        }
    }
}
