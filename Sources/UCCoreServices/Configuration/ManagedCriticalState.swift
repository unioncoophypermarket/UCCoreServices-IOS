//
//  ManagedCriticalState.swift
//  UCCoreServices
//
//  Created by Mahmoud Alaa on 31/10/2025.
//

import Foundation
import os.lock

// Minimal lock-backed critical state wrapper to avoid depending on toolchain ManagedCriticalState.
final class _UnfairLock {
    private var lock = os_unfair_lock_s()
    @inline(__always)
    func withLock<T>(_ body: () throws -> T) rethrows -> T {
        os_unfair_lock_lock(&lock)
        defer { os_unfair_lock_unlock(&lock) }
        return try body()
    }
}

// Generic wrapper that mimics the API we use: withCriticalRegion(_:)
struct ManagedCriticalState<State> {
    private let lock = _UnfairLock()
    private var _state: State
    init(_ initialValue: State) {
        self._state = initialValue
    }
    mutating func withCriticalRegion<R>(_ body: (inout State) throws -> R) rethrows -> R {
        try lock.withLock {
            try body(&self._state)
        }
    }
}
