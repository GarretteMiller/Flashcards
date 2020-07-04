//
//  SelectionViewController.swift
//  Flashcards
//
//  Created by Garrett miller on 6/19/20.
//  Copyright © 2020 Garrett miller. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController {

    var selectionView = SelectionView()

    override func viewDidAppear(_ animated: Bool) {
        selectionView.animateToStart(duration: 1)
    }

    override func viewDidLoad() {
        selectionView.decks = PersistenceService.shared.fetchDecks()

        if selectionView.decks.isEmpty {
            PersistenceService.shared.createDefaultDeck()
            selectionView.decks = PersistenceService.shared.fetchDecks()
            selectionView.deckCV.reloadData()
        }
        selectionView.deckCV.reloadData()

        setupView()
    }

    override func loadView() {
        self.view = selectionView
        selectionView.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupView() {
        NSLayoutConstraint.activate([
            selectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            selectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            selectionView.heightAnchor.constraint(equalToConstant: 240),
            selectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}
