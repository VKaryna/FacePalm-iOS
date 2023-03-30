//
//  Settings.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 30.03.23.
//

import SwiftUI

struct Settings {
    static let thumbnailSize = CGSize(width: 150, height: 250)
    static let cardSize = CGSize(width: 1300, height: 1600)

    static func thumbnailSize(size: CGSize) -> CGSize {
      let threshold: CGFloat = 500
      var scale: CGFloat = 0.12
      if size.width > threshold && size.height > threshold {
        scale = 0.2
      }
      return CGSize(
        width: Settings.cardSize.width * scale,
        height: Settings.cardSize.height * scale)
    }
}
