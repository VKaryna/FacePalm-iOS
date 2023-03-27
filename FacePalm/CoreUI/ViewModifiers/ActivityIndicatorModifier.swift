//
//  ActivityIndicatorModifier.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 01.03.23.
//

import SwiftUI

struct ActivityIndicatorModifier: ViewModifier {
    var isInProgress: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            ProgressView()
                .opacity(isInProgress ? 1 : 0)
                .tint(.white)
            content.opacity(isInProgress ? 0 : 1)
        }
    }
}

extension View {
    
    func activityIndicator(isInProgress: Bool) -> some View {
        modifier(ActivityIndicatorModifier(isInProgress: isInProgress))
    }
}
