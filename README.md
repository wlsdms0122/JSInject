# JSInject
![release](https://img.shields.io/badge/Release-1.1.1-green)

This is `Swift` DI (Dependency Injection) container using `@propertyWrapper` of `Swift 5.1`.

# Installation
### Cocoapods
```
pod 'JSInject'
```

# Usage
### Register
You can register using `Container`. I think `AppDelegate` is suitable position to register objects.
```swift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Register services into container
        Container.shared.register(Animal.self) { Animal("Steve") }
        ...
    }
}
```

Support options like multi container or multi dependency using name.
```swift
public class Container {
    public func register<Value: AnyObject>(
        _ type: Value.Type,
        scope: Scope = .global,
        name: String? = nil,
        container: String = Name.default,
        factory: @escaping () -> Value
    )
    ...
}
```

### Inject
You can injected using `@Inject` property wrapper.
```swift
class AnyClass {
    @Inject()
    var animal: Animal
    
    @Inject(name: "stub") 
    var animal: Animal
    
    @Inject(name: "stub", container: "test") 
    var animal: Animal
}
```

If you want to decide kind of dependency inject when instantiate a object, use `setName()` or `setContainer()`

```swift
class AnyClass {
    @Inject()
    var animal: Animal

    init(isTest: Bool) {
        if isTest {
            // Get origin property wrapper object using '_' prefix.
            _animal.setName("test")
        }
    }
}
```

just done! 🤣

### Scope
`JSInject` servce 3 kinds of scope of object living.

```swift
public enum Scope {
    case global
    case retain
    case property
}
```

- `.global`
    Object alive during application is living.
- `.retain`
    Object alive by retain cycle.
- `.property`
    Object will instantiate every time.
    
If you want to see how to work it, See demo application.


# Reference
I was inspired this [post](https://basememara.com/swift-dependency-injection-via-property-wrapper/).

# Contribution
This is a idea for DI. So any ideas, issues, opinions are welcome.

# License
`JSInject` is available under the MIT license.
