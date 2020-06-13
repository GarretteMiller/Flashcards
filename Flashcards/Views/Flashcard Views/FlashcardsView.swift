//
//  FlashcardsView.swift
//  Flashcards
//
//  Created by Garrett miller on 4/19/20.
//  Copyright © 2020 Garrett miller. All rights reserved.
//

import UIKit

class FlashcardsView: UIView {

    let arrowImage = UIImage(named: "arrow")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
    let xImage = UIImage(named: "xmark")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
    let checkImage = UIImage(named: "checkmark")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)

    private lazy var arrowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = UIColor.blue.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = .init(width: 1.0, height: 3.0)
        button.layer.shadowRadius = 3
        button.setBackgroundImage(arrowImage, for: .init())
        button.addTarget(self, action: #selector(arrowButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var xButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = UIColor.red.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = .init(width: 1.0, height: 3.0)
        button.layer.shadowRadius = 3
        button.setBackgroundImage(xImage, for: .init())
        button.addTarget(self, action: #selector(xButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var checkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = UIColor.green.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = .init(width: 1.0, height: 3.0)
        button.layer.shadowRadius = 3
        button.setBackgroundImage(checkImage, for: .init())
        button.addTarget(self, action: #selector(checkButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    var activeCards = [CardView]()
    var cards = [CardView]()
    var activeCardContents = [UILabel]()

    fileprivate var xConstr1 = [NSLayoutConstraint]()
    fileprivate var xConstr2 = [NSLayoutConstraint]()
    var notecardIndex = Int()
    var sideShowing = Bool()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
        setupView()
    }

    func setupView() {
        for num in 0..<10 {
            cards.append(CardView(cardFront: CardModel(text: "this is card number \(num+1)"),
                                  cardBack: CardModel(text: "back of card number \(num+1)")))
        }

        for (index, card) in cards.enumerated() {
            activeCards.append(card)
            self.addSubview(activeCards[index])
            xConstr2.append(activeCards[index].centerXAnchor.constraint(equalTo: centerXAnchor))
            xConstr2[index].isActive = false
            xConstr1.append(activeCards[index].centerXAnchor.constraint(equalTo: centerXAnchor, constant: -400))
            xConstr1[index].isActive = true
        }

        notecardIndex = 0

        self.activeCards[self.notecardIndex].cardBack?.isHidden = true

        setupNotecards()
        setupButtons()
    }

    @objc func arrowButtonTapped(_ sender: UIButton!) {
        if notecardIndex < activeCards.count {
            self.xConstr1[self.notecardIndex].isActive = false
            self.xConstr2[self.notecardIndex].isActive = true

            UIView.animateKeyframes(withDuration: 1,
            delay: 0,
            options: .calculationModeLinear,
            animations: {
                UIView.addKeyframe(
                withRelativeStartTime: 0.0,
                relativeDuration: 1) {
                    self.layoutIfNeeded()
                }
            })
            notecardIndex += 1
        }
    }

    @objc func checkButtonTapped(_ sender: UIButton!) {
        print("flip")
        //perform(#selector(flip), with: nil, afterDelay: 1)
    }

    @objc func xButtonTapped(_ sender: UIButton!) {
        if notecardIndex > 1 {
            self.xConstr2[self.notecardIndex-1].isActive = false
            self.xConstr1[self.notecardIndex-1].isActive = true

            UIView.animateKeyframes(withDuration: 1, //1
            delay: 0, //2
            options: .calculationModeLinear, //3
            animations: { //4
                UIView.addKeyframe( //5
                withRelativeStartTime: 0.0, //6
                relativeDuration: 0.5) { //7
                    self.layoutIfNeeded()                }
            })
            notecardIndex -= 1
        }
    }

    func setupNotecards() {
        for (index, card) in activeCards.enumerated() {
            activeCardContents.append(UILabel())

            card.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
            card.layer.shadowColor = UIColor.black.cgColor
            card.layer.shadowOpacity = 0.05
            card.layer.shadowOffset = .init(width: 1.0, height: 3.0)
            card.layer.shadowRadius = 3

            card.translatesAutoresizingMaskIntoConstraints = false
            card.widthAnchor.constraint(equalToConstant: 350).isActive = true
            card.heightAnchor.constraint(equalToConstant: 210).isActive = true
            card.topAnchor.constraint(equalTo: topAnchor).isActive = true

            card.addSubview(activeCardContents[index])
            activeCardContents[index].text = activeCards[index].cardFront?.text
            activeCardContents[index].text = activeCards[index].cardBack?.text
            activeCardContents[index].textAlignment = .center
            notecardsContentConstraints(index: index)
        }
    }

    func setupButtons() {
        addSubview(checkButton)
        addSubview(xButton)
        addSubview(arrowButton)

        NSLayoutConstraint.activate([
            checkButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            checkButton.widthAnchor.constraint(equalToConstant: 50),
            checkButton.heightAnchor.constraint(equalToConstant: 50),
            checkButton.bottomAnchor.constraint(equalTo: bottomAnchor),

            xButton.trailingAnchor.constraint(equalTo: checkButton.leadingAnchor, constant: -50),
            xButton.widthAnchor.constraint(equalToConstant: 50),
            xButton.heightAnchor.constraint(equalToConstant: 50),
            xButton.bottomAnchor.constraint(equalTo: bottomAnchor),

            arrowButton.leadingAnchor.constraint(equalTo: checkButton.trailingAnchor, constant: 50),
            arrowButton.widthAnchor.constraint(equalToConstant: 50),
            arrowButton.heightAnchor.constraint(equalToConstant: 50),
            arrowButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func notecardsContentConstraints(index: Int) {
        activeCardContents[index].translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            activeCardContents[index].widthAnchor.constraint(equalToConstant: 300),
            activeCardContents[index].heightAnchor.constraint(equalToConstant: 160),
            activeCardContents[index].centerXAnchor.constraint(equalTo: self.activeCards[index].centerXAnchor),
            activeCardContents[index].centerYAnchor.constraint(equalTo: self.activeCards[index].centerYAnchor)
        ])
    }
}
