//
//  FlashcardView.swift
//  Flashcards
//
//  Created by Garrett miller on 6/22/20.
//  Copyright © 2020 Garrett miller. All rights reserved.
//

import UIKit

class FlashcardsView: UIView {

    let checkImage = UIImage(systemName: "arrow.clockwise.circle")?
        .withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
    let arrowImage = UIImage(systemName: "arrow.right.circle")?
        .withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
    let xImage = UIImage(systemName: "arrow.left.circle")?
        .withTintColor(.systemRed, renderingMode: .alwaysOriginal)
    let shuffleImage = UIImage(systemName: "shuffle")?
        .withTintColor(.label, renderingMode: .alwaysOriginal)

    private lazy var arrowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = UIColor.blue.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = .init(width: 1.0, height: 3.0)
        button.layer.shadowRadius = 3
        button.setBackgroundImage(arrowImage, for: .init())
        button.addTarget(self, action: #selector(rightArrowButtonTapped(_:)), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(flipButtonTapped(_:)), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(leftArrowButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var shuffleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(shuffleImage, for: .init())
        button.addTarget(self, action: #selector(shuffleButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var frontLabel: UILabel = {
        var label = UILabel()
        label.text = "Front"
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var backLabel: UILabel = {
        var label = UILabel()
        label.text = "Back"
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.heavy)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var cardNumberLabel: UILabel = {
        var label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var topCard = 0
    var cardArray = [Card]()
    var topCardView = CardView()
    var bottomCardView = CardView()
    var notecardIndex: Int = 0

    var deck: Deck! {
        didSet {
            notecardIndex = 0
            cardNumberLabel.text = "\(notecardIndex + 1) out of \(deck.contains.count)"
            cardArray = Array(deck.contains)
            cardArray = cardArray.sorted(by: {
                $0.timeStamp.compare($1.timeStamp) == .orderedDescending
            })

            topCardView.setFrontAndBack(front: cardArray[0].frontText ?? "",
                                             back: cardArray[0].backText ?? "")
            bottomCardView.setFrontAndBack(front: cardArray[0].frontText ?? "",
                                             back: cardArray[0].backText ?? "")
            topCardView.flipToFront()
            bottomCardView.flipToFront()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        if PersistenceService.shared.fetchDecks().first == nil {
            PersistenceService.shared.createDefaultDeck()
        }
        deck = PersistenceService.shared.fetchDecks().first

        addSubview(arrowButton)
        addSubview(checkButton)
        addSubview(xButton)
        addSubview(shuffleButton)
        addSubview(bottomCardView)
        addSubview(topCardView)
        addSubview(frontLabel)
        addSubview(backLabel)
        addSubview(cardNumberLabel)

        bottomCardView.translatesAutoresizingMaskIntoConstraints = false
        topCardView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            bottomCardView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            bottomCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomCardView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            bottomCardView.trailingAnchor.constraint(equalTo: trailingAnchor),

            topCardView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            topCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topCardView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            topCardView.trailingAnchor.constraint(equalTo: trailingAnchor),

            shuffleButton.topAnchor.constraint(equalTo: topAnchor),
            shuffleButton.widthAnchor.constraint(equalToConstant: 25),
            shuffleButton.heightAnchor.constraint(equalToConstant: 25),
            shuffleButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: 175),

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
            arrowButton.bottomAnchor.constraint(equalTo: bottomAnchor),

            frontLabel.topAnchor.constraint(equalTo: topAnchor),
            frontLabel.leadingAnchor.constraint(equalTo: centerXAnchor, constant: -175),
            frontLabel.heightAnchor.constraint(equalToConstant: 25),

            backLabel.topAnchor.constraint(equalTo: topAnchor),
            backLabel.leadingAnchor.constraint(equalTo: centerXAnchor, constant: -175),
            backLabel.heightAnchor.constraint(equalToConstant: 25),

            cardNumberLabel.topAnchor.constraint(equalTo: topAnchor),
            cardNumberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            cardNumberLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }

    @objc func flipButtonTapped(_ sender: UIButton!) {
        bottomCardView.isHidden = true
        self.frontLabel.isHidden.toggle()
        self.backLabel.isHidden.toggle()
        topCardView.flip()
        bottomCardView.isHidden = false
    }

    @objc func shuffleButtonTapped(_ sender: UIButton!) {
        cardArray.shuffle()
        topCardView.setFrontAndBack(front: cardArray[0].frontText ?? "",
                                         back: cardArray[0].backText ?? "")
        bottomCardView.setFrontAndBack(front: cardArray[0].frontText ?? "",
                                         back: cardArray[0].backText ?? "")
        notecardIndex = 0
        cardNumberLabel.text = "\(notecardIndex + 1) out of \(deck.contains.count)"

        frontLabel.isHidden = false
        backLabel.isHidden = true
    }

    @objc func rightArrowButtonTapped(_ sender: UIButton!) {
        if notecardIndex < deck.contains.count - 1 {
            bottomCardView.setFrontAndBack(front: cardArray[notecardIndex+1].frontText ?? "",
                                           back: cardArray[notecardIndex+1].backText ?? "")

            topCardView.shiftRight()
            topCardView.setFrontAndBack(front: cardArray[notecardIndex+1].frontText ?? "",
                                        back: cardArray[notecardIndex+1].backText ?? "")

            notecardIndex += 1
            cardNumberLabel.text = "\(notecardIndex + 1) out of \(deck.contains.count)"

            frontLabel.isHidden = false
            backLabel.isHidden = true
        }
    }

    @objc func leftArrowButtonTapped(_ sender: UIButton!) {
        if notecardIndex > 0 {
            bottomCardView.setFrontAndBack(front: cardArray[notecardIndex].frontText ?? "",
                                           back: cardArray[notecardIndex].backText ?? "")

            topCardView.shiftLeft(front: cardArray[notecardIndex-1].frontText ?? "",
                                  back: cardArray[notecardIndex-1].backText ?? "")

            notecardIndex -= 1
            cardNumberLabel.text = "\(notecardIndex + 1) out of \(deck.contains.count)"

            self.frontLabel.isHidden = false
            self.backLabel.isHidden = true
        }
    }
}
