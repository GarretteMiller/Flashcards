//
//  FlashcardsViewController.swift
//  Flashcards
//
//  Created by Garrett miller on 4/30/20.
//  Copyright © 2020 Garrett miller. All rights reserved.
//

import UIKit

class FlashcardsViewController: UIViewController {

    let flashcardsView = FlashcardsView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func loadView() {
        self.view = flashcardsView
        flashcardsView.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupView() {
        NSLayoutConstraint.activate([
            flashcardsView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            flashcardsView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            flashcardsView.heightAnchor.constraint(equalToConstant: 350),
            flashcardsView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}
