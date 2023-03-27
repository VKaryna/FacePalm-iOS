//
//  URL+appendingPathComponents.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 01.03.23.
//

import Foundation

extension URL {

    public func appendingPathComponents(_ components: String...) -> URL {
        components.reduce(self) { $0.appendingPathComponent($1) }
    }
}
