//
//  AppUnavailablePopupView.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 04.03.23.
//

import SwiftUI

import SwiftUI

struct AppUnavailablePopupView: View {
    
    var body: some View {
        VStack(spacing: 24) {
            titleView
            descriptionView
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 25)
        .padding(.vertical, 20)
    }
    
    private var titleView: some View {
        Text("The app is not available 🥲")
            .font(.futuraMedium(size: 20))
            .multilineTextAlignment(.center)
            .layoutPriority(1)
    }
    
    private var descriptionView: some View {
        Text("Our team is working hard to fix it as soon as possible.")
            .multilineTextAlignment(.center)
            .font(.futuraMedium(size: 18))
            .foregroundColor(.fpGray)
    }
}

struct AppUnavailablePopupView_Previews: PreviewProvider {
    static var previews: some View {
        AppUnavailablePopupView()
    }
}
