//
//  GameNotificationsSubject.swift
//  FacePalm
//
//  Created by Pavel Vaitsikhouski on 11.04.23.
//

import Combine

final class SingleSubscriberSubject<Output, Failure>: Publisher where Failure: Error {
    typealias Output = Output
    typealias Failure = Failure
    
    var subscriber: AnySubscriber<Output, Failure>?
    
    func receive<S>(subscriber: S) where S: Subscriber, S.Failure == Failure, S.Input == Output {
        self.subscriber?.receive(completion: .finished)
        self.subscriber = AnySubscriber(subscriber)
        
        let subscription = Subscription<S>(subject: self)
        subscriber.receive(subscription: subscription)
    }
    
    func send(_ value: Output) {
        _ = subscriber?.receive(value)
    }
}

private extension SingleSubscriberSubject {
    
    final class Subscription<S: Subscriber>: Combine.Subscription where S.Failure == Failure, S.Input == Output {
        
        private let subject: SingleSubscriberSubject
        
        init(subject: SingleSubscriberSubject) {
            self.subject = subject
        }
        
        func request(_ demand: Subscribers.Demand) {
        }
        
        func cancel() {
            subject.subscriber?.receive(completion: .finished)
            subject.subscriber = nil
        }
    }
}
