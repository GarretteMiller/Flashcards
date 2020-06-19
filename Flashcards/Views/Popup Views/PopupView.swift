//
//  EditDeckView.swift
//  Flashcards
//
//  Created by Garrett miller on 4/19/20.
//  Copyright © 2020 Garrett miller. All rights reserved.
//

import UIKit

enum State {
    case closed
    case editing
}

extension State {
    var next: State {
        switch self {
        case .closed: return .editing
        case .editing: return .closed
        }
    }
}

protocol PopupDelegate: class {
    func didClosePopup()
}

class PopupView: UIView, EditDelegate, SelectionDelegate {

    weak var delegate: PopupDelegate?
    var currentState: State = .closed
    var runningAnimators = [UIViewPropertyAnimator]()
    var animationProgress = [CGFloat]()

    private lazy var safeAreaCover: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var selectDeckPopupView: SelectDeckPopupView = {
        let view = SelectDeckPopupView(frame: self.frame)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.chevButton.addGestureRecognizer(touchArrowRecognizer)
        view.cellDelegate = self
        view.selectionDelegate = self
        return view
    }()

    lazy var editDeckPopupView: EditDeckPopupView = {
        let view = EditDeckPopupView(frame: self.frame)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        selectDeckPopupView.decks = PersistenceService.shared.fetchDecks()

        if selectDeckPopupView.decks.isEmpty {
            PersistenceService.shared.createDefaultDeck()
            selectDeckPopupView.decks = PersistenceService.shared.fetchDecks()
            selectDeckPopupView.deckCV.reloadData()
            editDeckPopupView.deck = selectDeckPopupView.decks.first
        }

        selectDeckPopupView.deckCV.reloadData()

        setupView()
    }

    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
        setupView()
    }

// MARK: View Setup

    private func setupView() {
        addSubview(selectDeckPopupView)
        addSubview(editDeckPopupView)
        addSubview(safeAreaCover)

        NSLayoutConstraint.activate([
            safeAreaCover.widthAnchor.constraint(equalTo: widthAnchor),
            safeAreaCover.leadingAnchor.constraint(equalTo: leadingAnchor),
            safeAreaCover.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            safeAreaCover.heightAnchor.constraint(equalToConstant: 50),

            editDeckPopupView.leadingAnchor.constraint(equalTo: leadingAnchor),
            editDeckPopupView.trailingAnchor.constraint(equalTo: trailingAnchor),
            editDeckPopupView.heightAnchor.constraint(equalToConstant: 585),
            editDeckPopupView.bottomAnchor.constraint(equalTo: bottomAnchor),

            selectDeckPopupView.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectDeckPopupView.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectDeckPopupView.heightAnchor.constraint(equalToConstant: 240),
            selectDeckPopupView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        bringSubviewToFront(selectDeckPopupView)
        bringSubviewToFront(safeAreaCover)
    }

// MARK: Core Data Actions

    func createDefaultDeck() {
        PersistenceService.shared.createDefaultDeck()
        selectDeckPopupView.decks = PersistenceService.shared.fetchDecks()
        selectDeckPopupView.deckCV.reloadData()
        editDeckPopupView.deck = selectDeckPopupView.decks.first
    }

    func didSaveDeck(deckToSave: Deck) {
        var card = Card(context: PersistenceService.shared.context)
        for item in editDeckPopupView.deckData {
            card = editDeckPopupView.deck!.contains.first { $0.objectID == item.objectID }!
            if item.frontText != card.frontText || item.backText != card.backText {
                card.frontText = item.frontText
                card.backText = item.backText
            }
        }
        PersistenceService.shared.saveContext()

        selectDeckPopupView.decks = PersistenceService.shared.fetchDecks()
        selectDeckPopupView.deckCV.reloadData()
        editDeckPopupView.deck = selectDeckPopupView.decks.first
    }

    func didAddCard() {
        let deck = editDeckPopupView.deck
        PersistenceService.shared.createDefaultCard(objectId: deck!.objectID)
        editDeckPopupView.deck = deck
        editDeckPopupView.cardPicker.reloadAllComponents()
    }

    func didCreateNewDeck() {
        PersistenceService.shared.createDefaultDeck()
        selectDeckPopupView.decks = PersistenceService.shared.fetchDecks()
        selectDeckPopupView.deckCV.reloadData()
        editDeckPopupView.deck = selectDeckPopupView.decks.first
    }

// MARK: Animations

    func animateToStart(duration: TimeInterval) {
        animateUpDownSelect(to: currentState.next, duration: duration)
    }

    private lazy var touchArrowRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupArrowTapped(recognizer:)))
        return recognizer
    }()

    @objc private func popupArrowTapped(recognizer: UITapGestureRecognizer) {
        animateUpDownSelect(to: currentState.next, duration: 1)
    }

}

// MARK: Cell Delegate

extension PopupView: DeckCVCellDelegate {
    func editDeck(_ deck: Deck) {
        editDeckPopupView.currentDeckID = deck.objectID
        editDeckPopupView.cardPicker.reloadAllComponents()
    }
}
