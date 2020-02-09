//
//  Container.swift
//  JSInject
//
//  Created by JSilver on 2020/02/09.
//  Copyright © 2020 JSilver. All rights reserved.
//

import Foundation

fileprivate protocol Dependency {
    var value: AnyObject? { get set }
    var scope: Scope { get }
    var factory: () -> AnyObject { get }
    
    init(scope: Scope, _ factory: @escaping () -> AnyObject)
}

fileprivate class StrongDependency: Dependency {
    var value: AnyObject?
    var scope: Scope
    var factory: () -> AnyObject
    
    required init(scope: Scope, _ factory: @escaping () -> AnyObject) {
        self.scope = scope
        self.factory = factory
    }
}

fileprivate class WeakDependency: Dependency {
    weak var value: AnyObject?
    var scope: Scope
    var factory: () -> AnyObject
    
    required init(scope: Scope, _ factory: @escaping () -> AnyObject) {
        self.scope = scope
        self.factory = factory
    }
}

/// Object living scope
public enum Scope {
    case global
    case retain
    case property
}

public class Container {
    /// Shared instance of `Container`
    public static let shared: Container = Container()
    
    private var container: [String: Dependency] = [:]
    
    /// Register a object into container
    /// - parameters:
    ///   - type: type of obejct to register
    ///   - scope: scope that object living (default: `.global`)
    ///   - factory: closure to instantiate object
    ///
    /// You can set scope if you want. default value is `.global`, it is live during app is living.
    /// `.local` scope is that object instantiate every time. `.retain` is that instantiate if not exist already instantiated object. It live by ratain cycle.
    public func register<Value: AnyObject>(_ type: Value.Type, scope: Scope = .global, factory: @escaping () -> Value) {
        let key = String(describing: Value.self)
        
        switch scope {
        case .global:
            container[key] = StrongDependency(scope: scope, factory)
            
        case .retain,
             .property:
            container[key] = WeakDependency(scope: scope, factory)
        }
    }
    
    /// Resolve object from container
    /// - returns: resolved object
    public func resolve<Value: AnyObject>() -> Value {
        let key = String(describing: Value.self)
        guard var service = container[key] else {
            fatalError("\(Value.self) wasn't registered in container.")
        }
        
        switch service.scope {
        case .global,
             .retain:
            if let value = service.value as? Value {
                // Return object if value already instantiated
                return value
            }
            
            // Instantiate object of service
            guard let value = service.factory() as? Value else {
                fatalError("dependency \(Value.self) not resolved.")
            }
            
            // Assign to refer instantiated object to container
            service.value = value
            return value
            
        case .property:
            // Instantiate object of service
            guard let value = service.factory() as? Value else {
                fatalError("dependency \(Value.self) not resolved.")
            }
            
            return value
        }
    }
}
