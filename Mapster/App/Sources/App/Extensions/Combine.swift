//
//  Combine.swift
//  Mapster
//
//  Created by User on 06.03.2024.
//

import Combine
import Dispatch

public extension Publisher {
    func receiveOnMainQueue() -> Publishers.ReceiveOn<Self, DispatchQueue> {
        receive(on: DispatchQueue.main)
    }
}
