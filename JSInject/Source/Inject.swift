//
//  Inject.swift
//  JSInject
//
//  Created by JSilver on 2020/02/09.
//  Copyright © 2020 JSilver. All rights reserved.
//

@propertyWrapper
public struct Inject<Value: AnyObject> {
    private var container: String
    private var name: String?
    
    /// Strong refer value
    private var value: Value
    public var wrappedValue: Value { value }
    
    public init(name: String? = nil, container: String = Container.Name.default) {
        self.container = container
        self.name = name
        
        value = Container.shared.resolve(name: name, container: container)
    }
    
    mutating public func setName(_ name: String?) {
        value = Container.shared.resolve(name: name, container: container)
        self.name = name
    }
    
    mutating public func setContainer(_ container: String) {
        value = Container.shared.resolve(name: name, container: container)
        self.container = container
    }
}
