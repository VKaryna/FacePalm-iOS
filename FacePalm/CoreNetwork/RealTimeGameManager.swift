//
//  RealTimeGameManager.swift
//  FacePalm
//
//  Created by Karyna Vaitsikhouskaya on 05.02.23.
//

import Foundation

typealias NetworkMessage = (Result<Game, Error>) -> ()

class RealTimeGameManager: NSObject {
    
    private var didReceive: NetworkMessage?

    private var urlSession: URLSession?
    private var socket: URLSessionWebSocketTask?
    
    private func connect(didReceive: @escaping NetworkMessage, gameId: String) {
        self.didReceive = didReceive
        let url = URL(string: "ws://localhost:8080/websocket?gameId=\(gameId)")!
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        socket = urlSession?.webSocketTask(with: url)
    }
    
    private func listenForMessage(){
        socket?.receive { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    switch response {
                    case .string(let message):
                        if let json = message.data(using: .utf8), let response = try? JSONDecoder().decode(GameResponse.self, from: json) {
                            let game = Game(response: response)
                            self?.didReceive?(.success(game))
                        }
                    default:
                        fatalError()
                    }
                case .failure(let error):
                    self?.didReceive?(.failure(error))
                }
                
                self?.listenForMessage()
            }
        }
    }

}

extension RealTimeGameManager {
    
    func establishConnection(gameId: String, didReceive: @escaping NetworkMessage) {
        connect(didReceive: didReceive, gameId: gameId)
        socket?.resume()
        listenForMessage()
    }
    
    func disconnect(){
        socket?.cancel(with: .goingAway, reason: nil)
    }
}

extension RealTimeGameManager: URLSessionWebSocketDelegate {
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("kk")
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("")
    }
}
