//
//  ButtonStyle.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 21.01.23.
//

import Foundation
import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    var buttonColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .font(.futuraMedium(size: 20))
            .padding(10)
            .foregroundColor(configuration.isPressed ? Color.white.opacity(0.5) : Color.white)
            .background(configuration.isPressed ? buttonColor.opacity(0.5) : buttonColor)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: Color.black.opacity(0.5), radius: 4, x: 2, y: 4)
            .scaleEffect(configuration.isPressed ? 1.05 : 1.0)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    
    static func primary(color: Color) -> Self {
        PrimaryButtonStyle(buttonColor: color)
    }
}

