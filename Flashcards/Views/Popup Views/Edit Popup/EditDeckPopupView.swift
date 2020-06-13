//
//  EditDeckPopupView.swift
//  Flashcards
//
//  Created by Garrett miller on 4/30/20.
//  Copyright © 2020 Garrett miller. All rights reserved.
//

import UIKit

protocol EditDelegate: class {
    func didSaveDeck(deckToSave: Deck)
    func didAddCard()
}

class EditDeckPopupView: UIView {

    let addCardImage = UIImage(systemName: "plus")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
    var popupOffset = CGFloat()
    var bottomConstraint = NSLayoutConstraint()
    var deckData = [Card]()
    var currentCard = 0

    lazy var titleBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var nameTextField: NameEditTextFieldView = {
        let nameTextField = NameEditTextFieldView()
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        return nameTextField
    }()

    private lazy var saveDeckButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveDeck), for: .touchUpInside)
        return button
    }()

    private lazy var addCardButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(addCardImage, for: .init())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addCard), for: .touchUpInside)
        return button
    }()

    private lazy var backdrop: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var popup: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Edit"
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.heavy)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var cardsLabel: UILabel = {
        let label = UILabel()
        label.text = "Cards"
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var frontTextField: EditTextFieldView = {
        let field = EditTextFieldView()
        field.setLabel(text: "Front")
        field.textField.textColor = .black
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    private lazy var backTextField: EditTextFieldView = {
        let field = EditTextFieldView()
        field.setLabel(text: "Back")
        field.textField.textColor = .black
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    lazy var cardPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .systemGray5
        picker.layer.cornerRadius = 5
        picker.dataSource = self
        picker.delegate = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    var deck: Deck? {
        didSet {
            nameTextField.textField.text = deck?.name
            deckData = Array(deck!.contains)
            cardPicker.reloadAllComponents()
            frontTextField.textField.text = deckData[0].frontText
            backTextField.textField.text = deckData[0].backText
            if deck!.contains.isEmpty { cardPicker.isUserInteractionEnabled = false }
        }
    }

    weak var persistenceService: PersistenceService?
    weak var delegate: EditDelegate?

    init(frame: CGRect, persistenceService: PersistenceService) {
        self.persistenceService = persistenceService

        super.init(frame: frame)

        self.popupOffset = 585
        createSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createSubviews()
    }

    // close keyboard on return tap
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

// MARK: Editing & Saving

    @objc func saveDeck() {
        if let deck = deck {
//            var card = Card(context: persistenceService!.context)
//            for item in deckData {
//                card = deck.contains.first { $0.objectID == item.objectID }!
//                if item.frontText != card.frontText || item.backText != card.backText {
//                    card = item
//                }
//            }
//            //deck.contains = Set<Card>(deckData)
//            persistenceService?.saveContext()
            delegate?.didSaveDeck(deckToSave: deck)
        }
    }

    @objc func addCard() {
        delegate?.didAddCard()
    }

}

// MARK: Picker View Functions

extension EditDeckPopupView: UIPickerViewDelegate, UIPickerViewDataSource {

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        frontTextField.textField.text = deckData[row].frontText
        backTextField.textField.text = deckData[row].backText
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let rowTitle = deckData[row].frontText else { return " "}
        return rowTitle
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return deck?.contains.count ?? 0
    }
}

// MARK: View Setup

extension EditDeckPopupView {
    private func createSubviews() {
        addSubview(popup)
        addSubview(titleBar)
        addSubview(titleLabel)
        popup.addSubview(backdrop)
        popup.addSubview(nameTextField)
        popup.addSubview(saveDeckButton)
        popup.addSubview(cardPicker)
        popup.addSubview(addCardButton)
        popup.addSubview(frontTextField)
        popup.addSubview(backTextField)
        popup.addSubview(cardsLabel)

        setupSubviews()
    }

    private func setupSubviews() {
        bottomConstraint = popup.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                                         constant: popupOffset)
        NSLayoutConstraint.activate([
            popup.leadingAnchor.constraint(equalTo: leadingAnchor),
            popup.trailingAnchor.constraint(equalTo: trailingAnchor),
            popup.heightAnchor.constraint(equalToConstant: 585),
            bottomConstraint,

            backdrop.topAnchor.constraint(equalTo: popup.topAnchor, constant: 110),
            backdrop.leadingAnchor.constraint(equalTo: leadingAnchor),
            backdrop.trailingAnchor.constraint(equalTo: trailingAnchor),
            backdrop.heightAnchor.constraint(equalToConstant: 260),

            titleBar.topAnchor.constraint(equalTo: popup.topAnchor),
            titleBar.leadingAnchor.constraint(equalTo: popup.leadingAnchor),
            titleBar.trailingAnchor.constraint(equalTo: popup.trailingAnchor),
            titleBar.heightAnchor.constraint(equalToConstant: 50),

            cardPicker.topAnchor.constraint(equalTo: popup.topAnchor, constant: 140),
            cardPicker.leadingAnchor.constraint(equalTo: popup.leadingAnchor, constant: 20),
            cardPicker.widthAnchor.constraint(equalToConstant: 120),
            cardPicker.heightAnchor.constraint(equalToConstant: 220),

            cardsLabel.bottomAnchor.constraint(equalTo: cardPicker.topAnchor, constant: -5),
            cardsLabel.leadingAnchor.constraint(equalTo: cardPicker.leadingAnchor, constant: 20),
            cardsLabel.heightAnchor.constraint(equalToConstant: 20),

            addCardButton.bottomAnchor.constraint(equalTo: cardPicker.topAnchor, constant: -5),
            addCardButton.trailingAnchor.constraint(equalTo: cardPicker.trailingAnchor, constant: -20),
            addCardButton.heightAnchor.constraint(equalToConstant: 20),
            addCardButton.widthAnchor.constraint(equalToConstant: 20),

            saveDeckButton.bottomAnchor.constraint(equalTo: cardsLabel.topAnchor, constant: -20),
            saveDeckButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            saveDeckButton.heightAnchor.constraint(equalToConstant: 30),
            saveDeckButton.widthAnchor.constraint(equalToConstant: 75),

            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameTextField.bottomAnchor.constraint(equalTo: cardsLabel.topAnchor, constant: -20),
            nameTextField.trailingAnchor.constraint(equalTo: saveDeckButton.leadingAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 30),

            frontTextField.topAnchor.constraint(equalTo: popup.topAnchor, constant: 140),
            frontTextField.leadingAnchor.constraint(equalTo: cardPicker.trailingAnchor, constant: 10),
            frontTextField.trailingAnchor.constraint(equalTo: popup.trailingAnchor, constant: -20),
            frontTextField.heightAnchor.constraint(equalToConstant: 110),

            backTextField.topAnchor.constraint(equalTo: frontTextField.bottomAnchor, constant: 20),
            backTextField.leadingAnchor.constraint(equalTo: cardPicker.trailingAnchor, constant: 10),
            backTextField.trailingAnchor.constraint(equalTo: popup.trailingAnchor, constant: -20),
            backTextField.heightAnchor.constraint(equalToConstant: 110),

            titleLabel.leadingAnchor.constraint(equalTo: popup.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: popup.trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: titleBar.centerYAnchor)
        ])

        popup.sendSubviewToBack(backdrop)
    }
}
