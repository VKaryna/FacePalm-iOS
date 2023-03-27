//
//  Screen.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 01.03.23.
//

import Foundation

enum Screen: Hashable {
    case home
    case players(gameId: String)
    case game(gameId: String, playerId: Int)
    case vote(gameId: String, playerId: Int)
    case results(gameId: String, playerId: Int)
}
