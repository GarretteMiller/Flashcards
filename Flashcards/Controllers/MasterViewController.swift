//
//  ViewController.swift
//  Flashcards
//
//  Created by Garrett miller on 4/15/20.
//  Copyright © 2020 Garrett miller. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController, MasterViewDelegate {

    private let masterView = MasterView()
    private let flashcardsVC = FlashcardsViewController()
    private let selectionVC = SelectionViewController()
    private let editVC = EditViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        masterView.delegate = self
        add(flashcardsVC)

        NSLayoutConstraint.activate([
            flashcardsVC.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            flashcardsVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            flashcardsVC.view.heightAnchor.constraint(equalToConstant: 300),
            flashcardsVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    override func loadView() {
        self.view = masterView
        self.view.translatesAutoresizingMaskIntoConstraints = false
    }

    // Master View chev up tapped
    func didOpenSelection(_ sender: UIButton) {
        add(selectionVC)
        selectionVC.selectionView.selectionDelegate = self

        NSLayoutConstraint.activate([
            selectionVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            selectionVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            //selectionVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            selectionVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    // Selection View cell edit button tapped
    func didOpenEdit(with deck: Deck) {
        add(editVC)
        editVC.editView.delegate = self
        editVC.editView.deck = deck

        editVC.editView.nameTextField.textField.text = deck.name
        editVC.editView.deckData = Array(deck.contains).sorted(by: {
            $0.timeStamp.compare($1.timeStamp) == .orderedDescending
        })
        editVC.editView.cardPicker.reloadAllComponents()
        editVC.editView.frontTextField.textField.text = editVC.editView.deckData[0].frontText
        editVC.editView.backTextField.textField.text = editVC.editView.deckData[0].backText

        NSLayoutConstraint.activate([
            editVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            editVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            //editVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            editVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func didPlayDeck(with deck: Deck) {
        flashcardsVC.flashcardsView.deck = deck
    }

}

extension MasterViewController: SelectionDelegate {

    func didCloseSelect() {
        selectionVC.remove()
    }

    func didTapEditDeck(deck: Deck) {
        selectionVC.remove()
        didOpenEdit(with: deck)
        print("edit")
    }

    func didTapPlayDeck(deck: Deck) {
        selectionVC.remove()
        didPlayDeck(with: deck)
        print("play")
    }

    func didTapDeleteDeck(deck: Deck) {
        guard PersistenceService.shared.deckCount() > 1 else { return }
        showDeleteWarning(deck: deck)
    }

    func didCreateNewDeck() {
        PersistenceService.shared.createDefaultDeck()
        selectionVC.selectionView.decks = PersistenceService.shared.fetchDecks()
        selectionVC.selectionView.deckCV.reloadData()
    }

    func showDeleteWarning(deck: Deck) {

        let alert = UIAlertController(title: "Delete \"\(deck.name ?? "")\"",
                                      message: "This will delete the deck permanently", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            DispatchQueue.main.async {
                PersistenceService.shared.context.delete(deck)
                PersistenceService.shared.saveContext()
                self.selectionVC.selectionView.deckCV.reloadData()
            }
        }

        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        present(alert, animated: true, completion: nil)
    }
}

extension MasterViewController: EditDelegate {

    func didClose(withChanges: Bool) {
        if withChanges {
            let alertController = UIAlertController(title: "Save or Discard Changes",
                                                message: "",
                                                preferredStyle: .alert)

            self.present(alertController, animated: true, completion: nil)
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {
                alertController.dismiss(animated: true, completion: nil)
            }
        } else {
            editVC.remove()
        }
    }

    func didSaveDeck() {
        editVC.editView.deck?.timeStamp = Date()
        PersistenceService.shared.saveContext()
        selectionVC.selectionView.deckCV.reloadData()
    }

    func didAddCard(deck: Deck) {
        PersistenceService.shared.createDefaultCard(objectId: deck.objectID)
        editVC.editView.deckData = Array(deck.contains).sorted(by: {
            $0.timeStamp.compare($1.timeStamp) == .orderedDescending
        })
        editVC.editView.frontTextField.textField.text = editVC.editView.deckData[0].frontText
        editVC.editView.backTextField.textField.text = editVC.editView.deckData[0].backText
        editVC.editView.cardPicker.selectRow(0, inComponent: 0, animated: true)
    }

    func didRemoveCard(deck: Deck, card: Card) {
        deck.removeFromContains(card)
        editVC.editView.deckData = Array(deck.contains).sorted(by: {
            $0.timeStamp.compare($1.timeStamp) == .orderedDescending
        })
        editVC.editView.frontTextField.textField.text =
            editVC.editView.deckData[editVC.editView.cardPicker.selectedRow(inComponent: 0)].frontText
        editVC.editView.backTextField.textField.text =
            editVC.editView.deckData[editVC.editView.cardPicker.selectedRow(inComponent: 0)].backText
    }

    func didDiscardChanges() {
        PersistenceService.shared.context.rollback()
    }
}
