//
//  Array+Safe.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 08.02.23.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        if count < index {
            return nil
        } else {
            return self[index]
        }
    }
}
