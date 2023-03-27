//
//  WaitingForOwnerStartPopup.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 03.03.23.
//

import SwiftUI

struct WaitingForOwnerStartPopup: View {
    @Binding var isPresented: Bool

    var body: some View {
        VStack(spacing: 16) {
            titleView
            okButton
        }
        .padding()
    }
    
    private var titleView: some View {
        Text("You should wait for owner to start the game 💤")
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

struct WaitingForOwnerStartPopup_Previews: PreviewProvider {
    static var previews: some View {
        WaitingForOwnerStartPopup(isPresented: .constant(true));
    }
}
