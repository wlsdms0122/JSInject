//
//  AViewController.swift
//  JSInjectDemo
//
//  Created by JSilver on 2020/02/09.
//  Copyright © 2020 JSilver. All rights reserved.
//

import UIKit
import JSInject
import RxSwift
import RxCocoa
import SnapKit

class AView: UIView {
    // MARK: - view property
    let nextButton: UIButton = {
        let view = UIButton()
        view.layer.borderColor = view.tintColor.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.setTitle("Next", for: .normal)
        view.setTitleColor(view.tintColor, for: .normal)
        return view
    }()
    
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
        
        [nextButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        nextButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
    }
}

class AViewController: UIViewController {
    // MARK: - view property
    private var aView: AView { view as! AView }
    private var nextButton: UIButton { aView.nextButton }
    
    // MARK: - property
    @Inject()
    var animal: Animal
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - lifecycle
    override func loadView() {
        view = AView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "A View Controller"
        
        bind()
        
        // Update injected object property
        print(animal.name)
        animal.name = "Jason"
    }
    
    // MARK: - bind
    private func bind() {
        nextButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let viewController = CViewController()
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    deinit {
        print("\(String(describing: self)) deinited.")
    }
}
