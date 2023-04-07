//
//  OnReceiveWhileVisible.swift
//  FacePalm
//
//  Created by Pavel Vaitsikhouski on 07.04.23.
//

import SwiftUI
import Combine

private struct OnReceiveWhileVisible<P>: ViewModifier where P: Publisher, P.Failure == Never {
    @State private var isVisible = false
    
    var publisher: P
    var completion: (P.Output) -> Void
    
    func body(content: Content) -> some View {
        content
            .onReceive(publisher) { value in
                if isVisible {
                    completion(value)
                }
            }
            .onAppear {
                isVisible = true
            }
            .onDisappear {
                isVisible = false
            }
    }
}

extension View {
    
    func onReceiveWhileVisible<P>(_ publisher: P, completion: @escaping (P.Output) -> Void) -> some View where P: Publisher, P.Failure == Never {
        modifier(OnReceiveWhileVisible(publisher: publisher, completion: completion))
    }
}
