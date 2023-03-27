//
//  WaitingForOthersPopup.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 09.02.23.
//

import SwiftUI

struct WaitingForOthersPopup: View {
    let readyPlayersCount: Int
    let totalPlayersCount: Int
    
    var body: some View {
        VStack(spacing: 16) {
            titleView
            descriptionView
        }
    }
    
    private var titleView: some View {
        Text("Waiting for others 💤")
            .font(.futuraMedium(size: 20))
    }
    
    private var descriptionView: some View {
        Text("Ready to go: \(readyPlayersCount)/\(totalPlayersCount)")
            .font(.futuraMedium(size: 18))
            .foregroundColor(.fpGray)
    }
}

struct WaitingForOthersPopup_Previews: PreviewProvider {
    static var previews: some View {
        WaitingForOthersPopup(readyPlayersCount: 1, totalPlayersCount: 2)
    }
}
