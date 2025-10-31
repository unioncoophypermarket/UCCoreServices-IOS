//
//  CoreServices.swift
//  CoreServices
//
//  Created by Mahmoud Alaa on 10/31/25.
//

import Foundation

public enum CoreServices {
    
    // Thread-safe shared storage (protected by our lock wrapper).
    // We opt out of concurrency checking since accesses are protected by the lock.
    nonisolated(unsafe) private static var storage = ManagedCriticalState<CoreServicesConfiguration?>(nil)
    
    /// Call exactly once at app launch.
    public static func configure(_ configuration: CoreServicesConfiguration) {
        self.storage.withCriticalRegion { config in
            precondition(config == nil, "CoreServices.configure(_) must only be called once.")
            config = configuration
        }
    }
    
    /// Read anywhere (no await, no MainActor hop).
    public static var configuration: CoreServicesConfiguration {
        self.storage.withCriticalRegion { config in
            guard let config else {
                fatalError("CoreServices.configure(_) must be called before first use.")
            }
            return config
        }
    }
}

