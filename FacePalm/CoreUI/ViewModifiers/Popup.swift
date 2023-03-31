//
//  Popup.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 31.01.23.
//

import Foundation
import SwiftUI

struct Popup<PopupContent>: ViewModifier where PopupContent: View {
    @Binding var isPresented: Bool
    let content: () -> PopupContent
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                backgroundView
                    .zIndex(1)
                    .onTapGesture {
                        isPresented = false
                    }
                popupContent()
                    .zIndex(2)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: isPresented)
    }
    
    private var backgroundView: some View {
        Color.black
            .opacity(0.5)
            .ignoresSafeArea()
            .transition(.opacity)
    }
    
    @ViewBuilder
    private func popupContent() -> some View {
        content()
            .frame(maxWidth: 500)
            .padding(.vertical, 16)
            .background(Color.fpCream)
            .cornerRadius(8)
            .padding(.horizontal, 32)
            .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

extension View {
    
    func popup<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        modifier(Popup(isPresented: isPresented, content: content))
    }
}
