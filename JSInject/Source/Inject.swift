//
//  Inject.swift
//  JSInject
//
//  Created by JSilver on 2020/02/09.
//  Copyright © 2020 JSilver. All rights reserved.
//

@propertyWrapper
public struct Inject<Value: AnyObject> {
    /// Strong refer value
    private let value: Value
    public var wrappedValue: Value { value }
    
    public init(container: String = Container.Name.default) {
        value = Container.shared.resolve(container: container)
    }
}
