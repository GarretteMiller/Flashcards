//
//  SelectionAnimations.swift
//  Flashcards
//
//  Created by Garrett miller on 6/19/20.
//  Copyright © 2020 Garrett miller. All rights reserved.
//

import UIKit

extension SelectionView {
    func animateUpDownSelect(to state: State, duration: TimeInterval) {
        guard runningAnimators.isEmpty else { return }

        let transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            switch state {
            case .editing:
                    self.bottomConstraint.constant = 0
                    self.titleBar.layer.cornerRadius = 10
                    self.popup.layer.cornerRadius = 10
                    self.chevButton.setBackgroundImage(self.chevDownImage, for: .init())
            case .closed:
                    self.bottomConstraint.constant = self.popupOffset
                    self.layer.cornerRadius = 0
                    self.titleBar.layer.cornerRadius = 0
                    self.chevButton.setBackgroundImage(self.chevUpImage, for: .init())
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
                self.bottomConstraint.constant = self.popupOffset
                guard let delegate = self.selectionDelegate else { return }
                delegate.didCloseSelect()
            case .editing:
                self.bottomConstraint.constant = 0
            }

            self.runningAnimators.removeAll()
        }

        transitionAnimator.startAnimation()
        runningAnimators.append(transitionAnimator)
    }
}
