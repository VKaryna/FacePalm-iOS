//
//  GameState.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 13.02.23.
//

import Foundation

struct GameState {
    let game: Game
    
    var isInProgress: Bool {
        game.status == "ROUND"
    }
    
    var isVoting: Bool {
        game.status == "VOTING"
    }
    
    var isResults: Bool {
        game.status == "RESULTS"
    }
    
    var isFinished: Bool {
        game.status == "FINISHED"
    }
    
    init(game: Game) {
        self.game = game
    }
}
