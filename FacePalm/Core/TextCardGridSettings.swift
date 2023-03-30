//
//  Settings.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 30.03.23.
//

import SwiftUI

struct TextCardGridSettings {
    static let thumbnailSize = CGSize(width: 150, height: 250)
    static let cardSize = CGSize(width: 1300, height: 1600)
    
    static func thumbnailSize(size: CGSize) -> CGSize {
        let threshold: CGFloat = 500
        var scale: CGFloat = 0.12
        if size.width > threshold && size.height > threshold {
            scale = 0.2
        }
        return CGSize(
            width: TextCardGridSettings.cardSize.width * scale,
            height: TextCardGridSettings.cardSize.height * scale)
    }
    
    static func columns(size: CGSize) -> [GridItem] {
        [GridItem(.adaptive(minimum: TextCardGridSettings.thumbnailSize(size: size).width))]
    }
}
