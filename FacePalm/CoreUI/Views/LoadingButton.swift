//
//  LoadingButton.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 22.01.23.
//

import Foundation
import SwiftUI

struct LoadingButton<Content: View>: View {
    @State private var isInProgress = false
    let action: () async -> Void
    let label: () -> Content

    var body: some View {
        Button {
            Task {
                isInProgress = true
                
                await action()
                
                isInProgress = false
            }
        } label: {
            ZStack {
                ProgressView()
                    .tint(.white)
                    .opacity(isInProgress ? 1 : 0)
                label()
                    .opacity(isInProgress ? 0 : 1)
            }
        }
        .disabled(isInProgress)
        .opacity(isInProgress ? 0.5 : 1)
    }
}
