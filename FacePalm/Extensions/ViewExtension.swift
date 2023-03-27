//
//  ViewExtension.swift
//  FacePalm
//
//  Created by Pavel Vaitsikhouski on 21.01.23.
//

import Foundation
import SwiftUI

extension View {
    func myButtonStyle() -> some View {
        Modified(content: self, modifier: MyButtonStyle())
    }
}
