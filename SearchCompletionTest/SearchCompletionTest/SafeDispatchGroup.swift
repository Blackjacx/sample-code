//
//  SafeDispatchGroup.swift
//  SearchCompletionTest
//
//  Created by Stefan Herold on 23.10.17.
//  Copyright © 2017 CodingCobra. All rights reserved.
//

import Foundation

class SafeDispatchGroup {

    private let group = DispatchGroup()
    private (set) var groupCount: Int = 0

    public func enter() {
        guard groupCount > 0 else { return }
        groupCount += 1
        group.enter()
    }

    public func leave() {
        guard groupCount > 0 else { return }
        groupCount -= 1
        group.leave()
    }

    public func reset() {

        while groupCount > 0 {
            group.leave()
        }
    }

    public func notify(queue: DispatchQueue = .main, execute: @escaping ()->Void) {
        group.notify(queue: queue, execute: execute)
    }
}
