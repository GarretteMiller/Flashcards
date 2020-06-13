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
    }

    override func loadView() {
        self.view = flashcardsView
    }
}
