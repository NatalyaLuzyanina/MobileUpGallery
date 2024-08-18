//
//  LoginView.swift
//  MobileUpGallery
//
//  Created by Natalia on 13.08.2024.
//

import UIKit

protocol LoginViewDelegate: AnyObject {
   func loginButtonTapped()
}

final class LoginView: UIView {
    
    weak var delegate: LoginViewDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.Login.title
        label.numberOfLines = .zero
        label.font = .systemFont(ofSize: 44, weight: .bold)
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle(Strings.Login.buttonTitle, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = .white
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setViews() {
        addSubview(titleLabel)
        addSubview(loginButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(170)
            $0.leading.equalToSuperview().inset(24)
        }
        
        loginButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(52)
        }
    }
    
    @objc private func loginButtonTapped() {
        delegate?.loginButtonTapped()
    }
}
