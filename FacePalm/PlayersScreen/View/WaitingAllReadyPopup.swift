//
//  WaitingAllReadyPopup.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 03.03.23.
//

import SwiftUI

struct WaitingAllReadyPopup: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            titleView
            okButton
        }
        .padding()
    }
    
    private var titleView: some View {
        Text("Waiting for all players to be ready 💤")
            .font(.futuraMedium(size: 20))
    }
    
    private var okButton: some View {
        Button() {
            isPresented = false
        } label: {
            Text("Ok")
        }
        .buttonStyle(.primary(color: Color.green))
        .frame(width: 140)
    }
}

struct WaitingAllReadyPopup_Previews: PreviewProvider {
    static var previews: some View {
        WaitingAllReadyPopup(isPresented: .constant(true));
    }
}
