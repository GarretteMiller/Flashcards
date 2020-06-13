//
//  PopupView+animations.swift
//  Flashcards
//
//  Created by Garrett miller on 5/28/20.
//  Copyright © 2020 Garrett miller. All rights reserved.
//

import UIKit

extension PopupView {
    func animateUpDownSelect(to state: State, duration: TimeInterval) {
        guard runningAnimators.isEmpty else { return }

        let transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            switch state {
            case .editing:
                    self.selectDeckPopupView.bottomConstraint.constant = 0
                    self.selectDeckPopupView.titleBar.layer.cornerRadius = 20
                    self.selectDeckPopupView.popup.layer.cornerRadius = 20
                    self.editDeckPopupView.bottomConstraint.constant = 0 //self.editPopupView.popupOffset
                    self.editDeckPopupView.layer.cornerRadius = 20
                    self.editDeckPopupView.titleBar.layer.cornerRadius = 20
                    self.selectDeckPopupView.chevButton.setBackgroundImage(self.selectDeckPopupView.chevDownImage,
                                                                           for: .init())
            case .closed:
                    self.selectDeckPopupView.bottomConstraint.constant = self.selectDeckPopupView.popupOffset
                    self.editDeckPopupView.bottomConstraint.constant = self.editDeckPopupView.popupOffset
                    self.editDeckPopupView.layer.cornerRadius = 0
                    self.editDeckPopupView.titleBar.layer.cornerRadius = 0
                    self.selectDeckPopupView.layer.cornerRadius = 0
                    self.selectDeckPopupView.titleBar.layer.cornerRadius = 0
                    self.selectDeckPopupView.chevButton.setBackgroundImage(self.selectDeckPopupView.chevUpImage,
                                                                           for: .init())
            }
            self.layoutIfNeeded()
        })

        transitionAnimator.addCompletion { position in
            switch position {
            case .start: self.currentState = state.next
            case .end: self.currentState = state
            case .current: ()
            @unknown default: fatalError()
            }

            switch self.currentState {
            case .closed:
                self.selectDeckPopupView.bottomConstraint.constant = self.selectDeckPopupView.popupOffset
                self.editDeckPopupView.bottomConstraint.constant = self.editDeckPopupView.popupOffset
                guard let delegate = self.delegate else { return }
                delegate.didClosePopup()
            case .editing:
                self.selectDeckPopupView.bottomConstraint.constant = 0
                self.editDeckPopupView.bottomConstraint.constant = 0
            }

            self.runningAnimators.removeAll()
        }

        transitionAnimator.startAnimation()
        runningAnimators.append(transitionAnimator)
    }
}
