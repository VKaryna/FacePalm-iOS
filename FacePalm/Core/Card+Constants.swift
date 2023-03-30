//
//  CGFloat+Constants.swift
//  FacePalm
//
//  Created by Pavel Vaitsikhouski on 30.03.23.
//

import SwiftUI

extension CGSize {
    
    static var cardSize: Self {
        let scale: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 0.12 : 0.2
        return Self(
            width: 1300 * scale,
            height: 1600 * scale
        )
    }
}

extension CGFloat {
    
    static var cardWidth: Self {
        CGSize.cardSize.width
    }
    
    static var cardHeight: Self {
        CGSize.cardSize.height
    }
}
