//
//  CardViewnew.swift
//  Flashcards
//
//  Created by Garrett miller on 6/22/20.
//  Copyright © 2020 Garrett miller. All rights reserved.
//

import UIKit

class CardView: UIView {

    private lazy var frontSide: CardSide = {
        let view = CardSide()
        view.backgroundColor = .white
        view.textLabel.text = "front"
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.05
        view.layer.shadowOffset = CGSize(width: -5, height: 5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var backSide: CardSide = {
        let view = CardSide()
        view.backgroundColor = .white
        view.textLabel.text = "back"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    var outConstraints = [NSLayoutConstraint]()
    var inConstraints = [NSLayoutConstraint]()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(front: String, back: String) {
        self.init()
        self.frontSide.textLabel.text = front
        self.backSide.textLabel.text = back
    }

    func setupViews() {
        addSubview(frontSide)
        addSubview(backSide)

        inConstraints = [frontSide.leadingAnchor.constraint(equalTo: trailingAnchor, constant: 100),
                          backSide.leadingAnchor.constraint(equalTo: trailingAnchor, constant: 100)]

        outConstraints = [frontSide.centerXAnchor.constraint(equalTo: centerXAnchor),
                         backSide.centerXAnchor.constraint(equalTo: centerXAnchor)]

        outConstraints[0].isActive = true
        outConstraints[1].isActive = true

        inConstraints[0].isActive = false
        inConstraints[1].isActive = false

        NSLayoutConstraint.activate([
            frontSide.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            frontSide.widthAnchor.constraint(equalToConstant: 350),
            frontSide.heightAnchor.constraint(equalToConstant: 210),

            backSide.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            backSide.widthAnchor.constraint(equalToConstant: 350),
            backSide.heightAnchor.constraint(equalToConstant: 210)

        ])
    }

    func setFrontAndBack(front: String, back: String) {
        frontSide.textLabel.text = front
        backSide.textLabel.text = back
    }

    func shiftRight() {
        outConstraints[0].isActive = false
        outConstraints[1].isActive = false

        inConstraints[0].isActive = true
        inConstraints[1].isActive = true

        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1) {
                self.layoutIfNeeded()
            }
        })

        frontSide.isHidden = false
        backSide.isHidden = true

        inConstraints[0].isActive = false
        inConstraints[1].isActive = false

        outConstraints[0].isActive = true
        outConstraints[1].isActive = true
    }

    func shiftLeft(front: String, back: String) {
        outConstraints[0].isActive = false
        outConstraints[1].isActive = false
        inConstraints[0].isActive = true
        inConstraints[1].isActive = true

        layoutIfNeeded()

        frontSide.textLabel.text = front
        backSide.textLabel.text = back

        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1) {
                self.inConstraints[0].isActive = false
                self.inConstraints[1].isActive = false
                self.outConstraints[0].isActive = true
                self.outConstraints[1].isActive = true

                self.layoutIfNeeded()
            }
        })

        frontSide.isHidden = false
        backSide.isHidden = true
    }

    func flip() {
        perform(#selector(flipAnimation), with: nil)
    }

    func flipToFront() {
        if frontSide.isHidden {
            flip()
        }
    }

    @objc func flipAnimation() {
        let transitionOptions: UIView.AnimationOptions = [.transitionCrossDissolve]

        UIView.transition(with: frontSide, duration: 0.3, options: transitionOptions, animations: {
            self.frontSide.isHidden.toggle()
        })

        UIView.transition(with: backSide, duration: 0.3, options: transitionOptions, animations: {
            self.backSide.isHidden.toggle()
        })
    }

    deinit {
        frontSide.removeFromSuperview()
        backSide.removeFromSuperview()
    }
}

class CardSide: UIView {

    fileprivate lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

     override init(frame: CGRect) {
         super.init(frame: frame)

         setupViews()
     }

     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }

    func setupViews() {
        addSubview(textLabel)

        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            textLabel.widthAnchor.constraint(equalToConstant: 350),
            textLabel.heightAnchor.constraint(equalToConstant: 210)
        ])
    }
}
