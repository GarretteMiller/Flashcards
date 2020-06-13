//
//  editTextField.swift
//  Flashcards
//
//  Created by Garrett miller on 5/24/20.
//  Copyright © 2020 Garrett miller. All rights reserved.
//

import UIKit

class EditTextFieldView: UIView, UITextFieldDelegate {

    private lazy var topLabel: UILabel = {
        let label = UILabel()
        label.font  = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var textField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .white
        field.layer.cornerRadius = 5
        field.contentVerticalAlignment = .top
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

    func setLabel(text: String) {
        topLabel.text = text
        textField.placeholder = "\(text) of the card"
    }

    private func setupViews() {
        addSubview(topLabel)
        addSubview(textField)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 90),

            topLabel.centerXAnchor.constraint(equalTo: textField.centerXAnchor),
            topLabel.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -5),
            topLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
}
