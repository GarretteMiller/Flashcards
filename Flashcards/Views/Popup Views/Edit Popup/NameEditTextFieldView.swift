//
//  NameEditTextFieldView.swift
//  Flashcards
//
//  Created by Garrett miller on 5/24/20.
//  Copyright © 2020 Garrett miller. All rights reserved.
//

import UIKit

class NameEditTextFieldView: UIView, UITextFieldDelegate {

    private lazy var topLabel: UILabel = {
        let label = UILabel()
        label.text = "Name:"
        label.font  = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var textField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .white
        field.textColor = .black
        field.layer.cornerRadius = 5
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        textField.delegate = self

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(topLabel)
        addSubview(textField)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 80),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            textField.heightAnchor.constraint(equalTo: heightAnchor),

            topLabel.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            topLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            topLabel.trailingAnchor.constraint(equalTo: textField.leadingAnchor, constant: -5),
            topLabel.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
}
