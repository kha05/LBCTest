//
//  AsynchronousOperation.swift
//  LBCTest
//
//  Created by Ha Kevin on 27/03/2021.
//

import Foundation

class AsynchronousOperation: Operation {
    override var isAsynchronous: Bool {
        true
    }
    
    override var isExecuting: Bool {
        state == .isExecuting
    }
    
    override var isFinished: Bool {
        if isCancelled && state != .isFinished { return true }
        return state == .isFinished
    }
    
    var state: State = .isReady {
        willSet {
            willChangeValue(forKey: newValue.rawValue)
            willChangeValue(forKey: state.rawValue)
        }
        didSet {
            didChangeValue(forKey: oldValue.rawValue)
            didChangeValue(forKey: state.rawValue)
        }
    }

    override func start() {
        state = .isExecuting
        main()
    }
}

extension AsynchronousOperation {
    enum State: String {
          case isReady, isExecuting, isFinished
      }
}
