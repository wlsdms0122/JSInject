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
    private var value: Value?
    public var wrappedValue: Value {
        mutating get {
            if let value = value {
                return value
            }
            
            let value: Value = Container.shared.resolve(name: name, container: container)
            self.value = value
            
            return value
        }
    }
    
    public init(name: String? = nil, container: String = Container.Name.default) {
        self.container = container
        self.name = name
    }
    
    mutating public func setName(_ name: String?) {
        self.name = name
        value = nil
    }
    
    mutating public func setContainer(_ container: String) {
        self.container = container
        value = nil
    }
}
