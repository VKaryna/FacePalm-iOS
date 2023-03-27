//
//  SecondaryButtonStyle.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 04.02.23.
//

import Foundation
import SwiftUI

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .font(.futuraMedium(size: 16))
            .padding(8)
            .foregroundColor(configuration.isPressed ? Color.white.opacity(0.5) : Color.white)
            .background(configuration.isPressed ? Color.green.opacity(0.5) : Color.green)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

extension ButtonStyle where Self == SecondaryButtonStyle {
    
    static func secondary() -> Self {
        SecondaryButtonStyle()
    }
}
