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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle(Strings.Login.buttonTitle, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
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
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 170),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            
            loginButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            loginButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    @objc private func loginButtonTapped() {
        delegate?.loginButtonTapped()
    }
}
