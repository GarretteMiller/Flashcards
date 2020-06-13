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
    private let popupVC = PopupViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        masterView.delegate = self
        add(flashcardsVC)

        NSLayoutConstraint.activate([
            flashcardsVC.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            flashcardsVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            flashcardsVC.view.heightAnchor.constraint(equalToConstant: 300),
            flashcardsVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    override func loadView() {
        self.view = masterView
        self.view.translatesAutoresizingMaskIntoConstraints = false
    }

    func didOpenPopup(_ sender: UIButton) {
        add(popupVC)

        NSLayoutConstraint.activate([
            popupVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            popupVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            popupVC.view.heightAnchor.constraint(equalToConstant: 650),
            popupVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

}
