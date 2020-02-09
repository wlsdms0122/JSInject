//
//  BViewController.swift
//  JSInjectDemo
//
//  Created by JSilver on 2020/02/09.
//  Copyright © 2020 JSilver. All rights reserved.
//

import UIKit
import JSInject
import SnapKit

class BView: UIView {
    // MARK: - view property
    
    // MARK: - property
    
    // MARK: - constructor
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private
    private func setUpLayout() {
        backgroundColor = .white
    }
}

class BViewController: UIViewController {
    // MARK: - property
    @Inject var animal: Animal
    
    // MARK: - lifecycle
    override func loadView() {
        view = BView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "B View Controller"
        
        print(animal.name)
        animal.name = "Jenny"
    }
    
    deinit {
        print("\(String(describing: self)) deinited.")
    }
}
