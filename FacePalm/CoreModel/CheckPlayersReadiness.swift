//
//  CheckPlayersReadiness.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 05.02.23.
//

import Foundation


struct CheckPlayersReadiness {
    let players: [Player]
    
    var readyPlayersCount: Int {
        players.filter { player in player.isReady }.count
    }
    
    var totalPlayersCount: Int {
        players.count
    }
    
    var isAtLeastThreePlayers: Bool {
        totalPlayersCount >= 3
    }
    
    var isAllReady: Bool {
        totalPlayersCount != 0 && readyPlayersCount == totalPlayersCount
    }
    
    init (players: [Player]) {
        self.players = players
    }
}
