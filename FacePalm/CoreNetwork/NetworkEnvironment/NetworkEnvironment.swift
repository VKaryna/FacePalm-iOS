//
//  NetworkEnvironment.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 01.03.23.
//

import Foundation

public enum NetworkEnvironment {
    case develop
    case production
}

public enum APIVersion: String {
    case v1
}

#if DEBUG
public var networkEnvironment = NetworkEnvironment.develop
#else
public var networkEnvironment = NetworkEnvironment.production
#endif

extension NetworkEnvironment {
    
    public var url: URL { self.url(.v1) }
    
    public func url(_ version: APIVersion) -> URL {
        baseURL.appendingPathComponents("/\(version.rawValue)")
    }

    private var baseURL: URL {
        switch self {
        case .production: return .production
        case .develop: return .develop
        }
    }
}

// MARK: -

private extension URL {
    static let production = URL(string: "https://api.justbookstudio.com/facepalm/api")!
    static let develop = URL(string: "http://localhost:8081/facepalm/api")!
}
