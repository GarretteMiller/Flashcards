//
//  EditViewController.swift
//  Flashcards
//
//  Created by Garrett miller on 6/20/20.
//  Copyright © 2020 Garrett miller. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {

    var editView = EditView()

    override func viewDidAppear(_ animated: Bool) {
        editView.animateToStart(duration: 1)
    }

    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        setupView()
    }

    override func loadView() {
        self.view = editView
        editView.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupView() {
        NSLayoutConstraint.activate([
            editView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            editView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            editView.heightAnchor.constraint(equalToConstant: 600),
            editView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        editView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.editView.bottomConstraint.constant = 0
            self.editView.popup.layoutIfNeeded()
        })
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard editView.bottomConstraint.constant == 0 else { return }
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue) else {return}
        let keyboardFrame = keyboardSize.cgRectValue

        if editView.raise {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.editView.bottomConstraint.constant = 50 - keyboardFrame.size.height
                self.editView.popup.layoutIfNeeded()
            })
        }
    }
}
