//
//  EditDeckPopupView.swift
//  Flashcards
//
//  Created by Garrett miller on 4/30/20.
//  Copyright © 2020 Garrett miller. All rights reserved.
//

import UIKit
import CoreData

protocol EditDelegate: class {
    func didClose(withChanges: Bool)
    func didSaveDeck()
    func didDiscardChanges()
    func didAddCard(deck: Deck)
    func didRemoveCard(deck: Deck, card: Card)
}

class EditView: UIView, EditTextFieldDelegate, EditNameDelegate {
    func setRaiseTrue() {
        raise = true
    }

    func setRaiseFalse() {
        raise = false
    }

    var popupOffset = CGFloat()
    var bottomConstraint = NSLayoutConstraint()
    var deckData = [Card]()

    var runningAnimators = [UIViewPropertyAnimator]()
    var animationProgress = [CGFloat]()
    var currentState: State = .closed

    let addCardImage = UIImage(systemName: "plus")?
        .withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
    let removeCardImage = UIImage(systemName: "minus")?
        .withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
    let chevDownImage = UIImage(systemName: "chevron.down.circle")?
        .withTintColor(.black, renderingMode: .alwaysOriginal)

    private lazy var safeAreaCover: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var titleBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var chevButton: UIButton = {
        let button = UIButton()
        button.addGestureRecognizer(touchArrowRecognizer)
        button.setBackgroundImage(chevDownImage, for: .init())
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var nameTextField: NameEditTextFieldView = {
        let nameTextField = NameEditTextFieldView()
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.delegate = self
        return nameTextField
    }()

    private lazy var saveDeckButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveDeck), for: .touchUpInside)
        return button
    }()

    private lazy var discardChangesButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemRed
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.setTitle("Discard", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(discardChanges), for: .touchUpInside)
        return button
    }()

    private lazy var addCardButton: UIButton = {
        let button = UIButton()
        button.setImage(addCardImage, for: .init())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addCard), for: .touchUpInside)
        return button
    }()

    private lazy var removeCardButton: UIButton = {
        let button = UIButton()
        button.setImage(removeCardImage, for: .init())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(removeCard), for: .touchUpInside)
        return button
    }()

    private lazy var backdrop: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var popup: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Edit"
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var cardsLabel: UILabel = {
        let label = UILabel()
        label.text = "Cards"
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var frontTextField: EditTextFieldView = {
        let field = EditTextFieldView()
        field.setLabel(text: "Front")
        field.delegate = self
        field.side = 0
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    lazy var backTextField: EditTextFieldView = {
        let field = EditTextFieldView()
        field.setLabel(text: "Back")
        field.delegate = self
        field.side = 1
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

    var deck: Deck?
    weak var delegate: EditDelegate?
    var raise = false

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.popupOffset = 480
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
        delegate?.didSaveDeck()
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    @objc func discardChanges() {
        delegate?.didDiscardChanges()
    }

    @objc func addCard() {
        delegate?.didAddCard(deck: deck!)
        cardPicker.reloadAllComponents()
    }

    @objc func removeCard() {
        guard deck!.contains.count > 1 else { return }
        delegate?.didRemoveCard(deck: deck!,
                                card: deckData[cardPicker.selectedRow(inComponent: 0)])
        cardPicker.reloadAllComponents()
    }

    func animateToStart(duration: TimeInterval) {
        animateUpDownEdit(to: currentState.next, duration: duration)
    }

    private lazy var touchArrowRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupArrowTapped(recognizer:)))
        return recognizer
    }()

    @objc private func popupArrowTapped(recognizer: UITapGestureRecognizer) {
        if PersistenceService.shared.context.hasChanges {
            delegate?.didClose(withChanges: true)
        } else {
            animateUpDownEdit(to: currentState.next, duration: 1)
        }
    }

// MARK: Text Field Changes

    func didMakeChangesText(changedText: String, side: Int) {
        switch side {
        case 0: deckData[cardPicker.selectedRow(inComponent: 0)].frontText = changedText
        case 1: deckData[cardPicker.selectedRow(inComponent: 0)].backText = changedText
        default:fatalError()
        }
        cardPicker.reloadAllComponents()
    }

    func didMakeChangesName(changedText: String) {
        deck?.name = changedText
    }

}

// MARK: Picker View Functions

extension EditView: UIPickerViewDelegate, UIPickerViewDataSource {

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
        return deckData.count
    }
}

// MARK: View Setup

extension EditView {
    private func createSubviews() {
        addSubview(popup)
        addSubview(safeAreaCover)
        popup.addSubview(titleBar)
        popup.addSubview(titleLabel)
        popup.addSubview(chevButton)
        popup.addSubview(backdrop)
        popup.addSubview(nameTextField)
        popup.addSubview(saveDeckButton)
        popup.addSubview(discardChangesButton)
        popup.addSubview(cardPicker)
        popup.addSubview(addCardButton)
        popup.addSubview(removeCardButton)
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
            popup.heightAnchor.constraint(equalToConstant: 480),
            bottomConstraint,

            safeAreaCover.widthAnchor.constraint(equalTo: widthAnchor),
            safeAreaCover.leadingAnchor.constraint(equalTo: leadingAnchor),
            safeAreaCover.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            safeAreaCover.heightAnchor.constraint(equalToConstant: 50),

            titleBar.topAnchor.constraint(equalTo: popup.topAnchor),
            titleBar.leadingAnchor.constraint(equalTo: popup.leadingAnchor),
            titleBar.trailingAnchor.constraint(equalTo: popup.trailingAnchor),
            titleBar.heightAnchor.constraint(equalToConstant: 50),

            cardPicker.topAnchor.constraint(equalTo: popup.topAnchor, constant: 140),
            cardPicker.leadingAnchor.constraint(equalTo: popup.leadingAnchor, constant: 20),
            cardPicker.widthAnchor.constraint(equalTo: popup.widthAnchor, multiplier: 0.65),
            cardPicker.heightAnchor.constraint(equalToConstant: 110),

            cardsLabel.bottomAnchor.constraint(equalTo: cardPicker.topAnchor, constant: -5),
            cardsLabel.leadingAnchor.constraint(equalTo: cardPicker.leadingAnchor),
            cardsLabel.heightAnchor.constraint(equalToConstant: 20),

            addCardButton.bottomAnchor.constraint(equalTo: cardPicker.topAnchor),
            addCardButton.trailingAnchor.constraint(equalTo: cardPicker.trailingAnchor, constant: -30),
            addCardButton.heightAnchor.constraint(equalToConstant: 30),
            addCardButton.widthAnchor.constraint(equalToConstant: 30),

            removeCardButton.bottomAnchor.constraint(equalTo: cardPicker.topAnchor),
            removeCardButton.trailingAnchor.constraint(equalTo: cardPicker.trailingAnchor),
            removeCardButton.heightAnchor.constraint(equalToConstant: 30),
            removeCardButton.widthAnchor.constraint(equalToConstant: 30),

            saveDeckButton.topAnchor.constraint(equalTo: cardPicker.topAnchor),
            saveDeckButton.leadingAnchor.constraint(equalTo: cardPicker.trailingAnchor, constant: 5),
            saveDeckButton.trailingAnchor.constraint(equalTo: popup.trailingAnchor, constant: -20),
            saveDeckButton.heightAnchor.constraint(equalTo: cardPicker.heightAnchor, multiplier: 0.55),

            discardChangesButton.topAnchor.constraint(equalTo: saveDeckButton.bottomAnchor, constant: 5),
            discardChangesButton.leadingAnchor.constraint(equalTo: cardPicker.trailingAnchor, constant: 5),
            discardChangesButton.trailingAnchor.constraint(equalTo: popup.trailingAnchor, constant: -20),
            discardChangesButton.bottomAnchor.constraint(equalTo: cardPicker.bottomAnchor),

            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameTextField.bottomAnchor.constraint(equalTo: cardsLabel.topAnchor, constant: -20),
            nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 30),

            frontTextField.topAnchor.constraint(equalTo: cardPicker.bottomAnchor, constant: 20),
            frontTextField.leadingAnchor.constraint(equalTo: popup.leadingAnchor, constant: 20),
            frontTextField.trailingAnchor.constraint(equalTo: popup.trailingAnchor, constant: -20),
            frontTextField.heightAnchor.constraint(equalToConstant: 80),

            backTextField.topAnchor.constraint(equalTo: frontTextField.bottomAnchor, constant: 20),
            backTextField.leadingAnchor.constraint(equalTo: popup.leadingAnchor, constant: 20),
            backTextField.trailingAnchor.constraint(equalTo: popup.trailingAnchor, constant: -20),
            backTextField.heightAnchor.constraint(equalToConstant: 80),

            titleLabel.centerXAnchor.constraint(equalTo: titleBar.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: titleBar.centerYAnchor),

            chevButton.trailingAnchor.constraint(equalTo: titleBar.trailingAnchor, constant: -20),
            chevButton.centerYAnchor.constraint(equalTo: titleBar.centerYAnchor),
            chevButton.widthAnchor.constraint(equalToConstant: 30),
            chevButton.heightAnchor.constraint(equalToConstant: 30),

            backdrop.topAnchor.constraint(equalTo: popup.topAnchor, constant: 110),
            backdrop.leadingAnchor.constraint(equalTo: leadingAnchor),
            backdrop.trailingAnchor.constraint(equalTo: trailingAnchor),
            backdrop.bottomAnchor.constraint(equalTo: popup.bottomAnchor)
        ])

        popup.sendSubviewToBack(backdrop)
    }
}
