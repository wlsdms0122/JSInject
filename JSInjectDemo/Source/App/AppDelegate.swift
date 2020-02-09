//
//  AppDelegate.swift
//  JSInjectDemo
//
//  Created by JSilver on 2020/02/09.
//  Copyright © 2020 JSilver. All rights reserved.
//

import UIKit
import JSInject

class Animal {
    var name: String
    
    init(_ name: String) {
        self.name = name
        
        print("\(String(describing: self)) inited.")
    }
    
    deinit {
        print("\(String(describing: self)) deinited.")
    }
}

class Rabbit: Animal {
    override init(_ name: String) {
        super.init(name)
    }
}

class Sloth: Animal {
    override init(_ name: String) {
        super.init(name)
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Register services into container
        Container.shared.register(Animal.self, name: "stub") { Rabbit("Steve") }
        Container.shared.register(Animal.self) { Sloth("John") }
//        Container.shared.register(Animal.self, scope: .retain) { Animal("Steve") }
//        Container.shared.register(Animal.self, scope: .property) { Animal("Steve") }
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = MainViewController()
        
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
}

