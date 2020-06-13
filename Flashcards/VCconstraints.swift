//
//  Constraints.swift
//  Flashcards
//
//  Created by Garrett miller on 4/15/20.
//  Copyright © 2020 Garrett miller. All rights reserved.
//

import Foundation

extension ViewController {

    func notecardConstraints() {
        noteCard.translatesAutoresizingMaskIntoConstraints = false
        noteCard.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noteCard.widthAnchor.constraint(equalToConstant: 350).isActive = true
        noteCard.heightAnchor.constraint(equalToConstant: 210).isActive = true
        noteCard.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
    }

    func prevButtonConstraints() {
        prevButton.translatesAutoresizingMaskIntoConstraints = false

        prevButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        prevButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        prevButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        prevButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200).isActive = true
    }

    func nextButtonConstraints() {
        nextButton.translatesAutoresizingMaskIntoConstraints = false

        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200).isActive = true
    }
}
