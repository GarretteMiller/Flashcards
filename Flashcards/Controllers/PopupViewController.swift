//
//  EditDeckViewController.swift
//  Flashcards
//
//  Created by Garrett miller on 4/19/20.
//  Copyright © 2020 Garrett miller. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController, PopupDelegate {

    let popupView = PopupView(frame: UIScreen.main.bounds,
                              persistenceService: PersistenceService.shared)

    override func viewDidAppear(_ animated: Bool) {
        popupView.animateToStart(duration: 1)
    }

    override func loadView() {
        self.view = popupView
        popupView.delegate = self
    }

    func didClosePopup() {
        remove()
    }
}
