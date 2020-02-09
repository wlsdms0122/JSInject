//
//  MainViewController.swift
//  JSInjectDemo
//
//  Created by JSilver on 2020/02/09.
//  Copyright © 2020 JSilver. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import JSInject
import SnapKit

class MainView: UIView {
    // MARK: - view property
    let oneButton: UIButton = {
        let view = UIButton()
        view.layer.borderColor = view.tintColor.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.setTitle("A", for: .normal)
        view.setTitleColor(view.tintColor, for: .normal)
        return view
    }()
    
    let twoButton: UIButton = {
        let view = UIButton()
        view.layer.borderColor = view.tintColor.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.setTitle("B", for: .normal)
        view.setTitleColor(view.tintColor, for: .normal)
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [oneButton, twoButton])
        view.axis = .vertical
        view.spacing = 10
        
        oneButton.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
        
        twoButton.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
        
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
        
        [stackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

class MainViewController: UIViewController {
    // MARK: - view property
    private var mainView: MainView { view as! MainView }
    private var oneButton: UIButton { mainView.oneButton }
    private var twoButton: UIButton { mainView.twoButton }
    
    // MARK: - property
    private var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - lifecycle
    override func loadView() {
        view = MainView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    // MARK: - bind
    func bind() {
        oneButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let viewController = UINavigationController(rootViewController: AViewController())
                self?.present(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        twoButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let viewController = BViewController()
                self?.present(viewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
