# JSInject
![release](https://img.shields.io/badge/Release-Yet-red)

This is `Swift` DI (Dependency Injection) container using `@propertyWrapper` of `Swift 5.1`.

# Installation
### Cocoapods
Sorry. not support `CocoaPods` yet.

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

### Inject
You can injected using `@Inject` property wrapper.
```swift
class AnyClass {
    @Inject var animal: Animal
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

public class Container {
    public func register<Value: AnyObject>(_ type: Value.Type, scope: Scope = .global, factory: @escaping () -> Value)
    ...
}
```

- `.global`
    Object alive during application is living.
- `.retain`
    Object alive by retain cycle.
- `.property`
    Object will instantiate every time.
    
If you want to see how to work it, See demo application.

# To Do
- testable

# Reference
I was inspired this [post](https://basememara.com/swift-dependency-injection-via-property-wrapper/).

# Contribution
This is a idea for DI. So any ideas, issues, opinions are welcome.

# License
`JSInject` is available under the MIT license.
