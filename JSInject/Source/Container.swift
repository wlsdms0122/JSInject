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

fileprivate typealias DependencyContainer = [String: Dependency]

public class Container {
    // MARK: - constant
    public enum Name {
        public static let `default` = "default"
        public static let `private` = "private"
    }
    
    /// Shared instance of `Container`
    public static let shared: Container = Container()
    
    // MARK: - property
    private var containers: [String: DependencyContainer] = [:]
    
    // MARK: - constructor
    private init() {
        containers[Name.default] = [:]
    }
    
    // MARK: - public
    /// Register a object into container
    /// - parameters:
    ///   - type: type of obejct to register
    ///   - scope: scope that object living (default: `.global`)
    ///   - container: name of container (default: `"default"`)
    ///   - factory: closure to instantiate object
    ///
    /// You can set scope if you want. default value is `.global`, it is live during app is living.
    /// `.local` scope is that object instantiate every time. `.retain` is that instantiate if not exist already instantiated object. It live by ratain cycle.
    public func register<Value: AnyObject>(
        _ type: Value.Type,
        scope: Scope = .global,
        name: String? = nil,
        container: String = Name.default,
        factory: @escaping () -> Value
    ) {
        let key = makeKey(type, name: name)
        let dependency = makeDependency(scope: scope, factory: factory)
        
        register(key: key, dependency: dependency, container: container)
    }
    
    /// Resolve object from container
    /// - parameters:
    ///   - container: name of container
    /// - returns: resolved object
    func resolve<Value: AnyObject>(
        name: String? = nil,
        container: String = Name.default
    ) -> Value {
        let key = makeKey(Value.self, name: name)
        return resolve(key: key, container: container)
    }
    
    // MARK: - private
    private func makeKey<Value>(_ type: Value.Type, name: String?) -> String {
        let key = String(describing: type)
        if let name = name {
            return "\(key)_\(name)"
        }
        return key
    }
    
    /// Make a dependency
    /// - parameters:
    ///   - scope: scope that object living (default: `.global`)
    ///   - factory: closure to instantiate object
    /// - returns: a specific dependency by scope
    private func makeDependency<Value: AnyObject>(scope: Scope, factory: @escaping () -> Value) -> Dependency {
        switch scope {
        case .global:
            return StrongDependency(scope: scope, factory)
            
        case .retain,
             .property:
            return WeakDependency(scope: scope, factory)
        }
    }
    
    /// Register dependency, If conatiner named `containerName` doesn't exist, register new container
    /// - parameters:
    ///   - key: key of dependency to register
    ///   - dependency: object to register
    ///   - name: name of container
    private func register(key: String, dependency: Dependency, container name: String) {
        if var container = containers[name] {
            // Register dependency
            container[key] = dependency
            // Reassign container
            containers[name] = container
        } else {
            // Register container
            let container: DependencyContainer = [key: dependency]
            containers[name] = container
        }
    }
    
    /// Get container by access level
    /// - parameters:
    ///   - name: name of container
    /// - returns: container by name
    private func getContainer(name: String) -> [String: Dependency] {
        guard let container = containers[name] else {
            fatalError("'\(name)' container not registered.")
        }
        return container
    }
    
    /// Resolve dependency
    /// - parameters:
    ///   - key: key of dependency
    ///   - name: name of container
    /// - returns: dependency
    private func resolve<Value: AnyObject>(key: String, container name: String) -> Value {
        // Get dependency from container named by `name`
        guard var dependency = getContainer(name: name)[key] else {
            fatalError("'\(Value.self)' dependency not registered in '\(name)' container.")
        }
        
        switch dependency.scope {
        case .global,
             .retain:
            if let value = dependency.value as? Value {
                // Return object if value already instantiated
                return value
            }
            
            // Instantiate object of service
            guard let value = dependency.factory() as? Value else {
                fatalError("'\(Value.self)' dependency not resolved.")
            }
            
            // Assign to refer instantiated object to container
            dependency.value = value
            return value
            
        case .property:
            // Instantiate object of service
            guard let value = dependency.factory() as? Value else {
                fatalError("'\(Value.self)' dependency not resolved.")
            }
            
            return value
        }
    }
}
