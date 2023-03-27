//
//  CardResponse.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 05.02.23.
//

import Foundation

struct CardResponse: Decodable {
    let id: Int
    let text: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
    }
}
