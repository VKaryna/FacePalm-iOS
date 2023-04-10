//
//  ShareContent.swift
//  FacePalm
//
//  Created by Pavel Vaitsikhouski on 10.04.23.
//

import Foundation

struct ShareContent {
    var gameID: String
    var content: String {
        """
        Hey! Join the Meme Battle!
        You can use game id to find me - \(gameID).
        If you don't have the app use the link to download it.
        https://apps.apple.com/app/facepalm-meme-battle/id6447070545
        """
    }
}
