//
//  NameEditTextFieldView.swift
//  Flashcards
//
//  Created by Garrett miller on 5/24/20.
//  Copyright © 2020 Garrett miller. All rights reserved.
//

import UIKit

protocol EditNameDelegate: class {
    func didMakeChangesName(changedText: String)
    func setRaiseFalse()
}

class NameEditTextFieldView: UIView, UITextFieldDelegate {

    private lazy var topLabel: UILabel = {
        let label = UILabel()
        label.text = "Name:"
        label.font  = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var textField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .systemGray5
        field.layer.cornerRadius = 5
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    weak var delegate: EditNameDelegate?
    var raise = false

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
            topLabel.topAnchor.constraint(equalTo: topAnchor),
            topLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            topLabel.heightAnchor.constraint(equalTo: heightAnchor),
            topLabel.widthAnchor.constraint(equalToConstant: 70),

            textField.centerYAnchor.constraint(equalTo: topLabel.centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: topLabel.trailingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.didMakeChangesName(changedText: textField.text ?? "")
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.setRaiseFalse()
    }
}
