//
//  Card.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 05.02.23.
//

import Foundation

struct Card: Identifiable, Equatable, Hashable {
    let id: Int
    let text: String
}

extension Card {
    init(response: CardResponse) {
        self.id = response.id
        self.text = response.text
    }
}
