//
//  PopupView.swift
//  Flashcards
//
//  Created by Garrett miller on 4/18/20.
//  Copyright © 2020 Garrett miller. All rights reserved.
//

import UIKit
import CoreData

protocol DeckCVCellDelegate: class {
    func editDeck(_ deck: Deck)
}

protocol SelectionDelegate: class {
    func didCreateNewDeck()
}

class SelectDeckPopupView: UIView {

    let addDeckImage = UIImage(systemName: "plus.circle")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
    let chevUpImage = UIImage(systemName: "chevron.up")?.withTintColor(.black, renderingMode: .alwaysOriginal)
    let chevDownImage = UIImage(systemName: "chevron.down")?.withTintColor(.black, renderingMode: .alwaysOriginal)

    var popupOffset = CGFloat()
    var bottomConstraint = NSLayoutConstraint()
    var decks = [Deck]()

    lazy var popup: UIView = {
        let view = UIView()
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.backgroundColor = .systemGray3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var titleBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var chevButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(chevUpImage, for: .init())
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Decks"
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.heavy)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var addDeckButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(addDeckImage, for: .init())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(newDeck(sender:)), for: .touchUpInside)
        return button
    }()

    lazy var deckCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: popup.bounds, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DeckCVCell.self, forCellWithReuseIdentifier: "DeckCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    weak var cellDelegate: DeckCVCellDelegate?
    weak var selectionDelegate: SelectionDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.popupOffset = 150
        addDeckButton.addTarget(self, action: #selector(newDeck(sender:)), for: .touchUpInside)
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @objc func newDeck(sender: UIButton) {
        selectionDelegate?.didCreateNewDeck()
    }

    // MARK: Constraints

    private func setupSubviews() {
        addSubview(popup)
        popup.addSubview(titleBar)
        popup.addSubview(titleLabel)
        popup.addSubview(chevButton)
        popup.addSubview(addDeckButton)
        popup.addSubview(deckCV)
        bottomConstraint = popup.bottomAnchor
                .constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: popupOffset)

        NSLayoutConstraint.activate([
            popup.leadingAnchor.constraint(equalTo: leadingAnchor),
            popup.trailingAnchor.constraint(equalTo: trailingAnchor),
            popup.heightAnchor.constraint(equalToConstant: 200),
            bottomConstraint,

            deckCV.topAnchor.constraint(equalTo: titleBar.bottomAnchor),
            deckCV.leadingAnchor.constraint(equalTo: popup.leadingAnchor, constant: 80),
            deckCV.bottomAnchor.constraint(equalTo: popup.bottomAnchor),
            deckCV.trailingAnchor.constraint(equalTo: popup.trailingAnchor),

            addDeckButton.centerYAnchor.constraint(equalTo: deckCV.centerYAnchor),
            addDeckButton.widthAnchor.constraint(equalToConstant: 30),
            addDeckButton.heightAnchor.constraint(equalToConstant: 30),
            addDeckButton.centerXAnchor.constraint(equalTo: popup.leadingAnchor, constant: 40),

            titleBar.topAnchor.constraint(equalTo: popup.topAnchor),
            titleBar.leadingAnchor.constraint(equalTo: popup.leadingAnchor),
            titleBar.trailingAnchor.constraint(equalTo: popup.trailingAnchor),
            titleBar.heightAnchor.constraint(equalToConstant: 50),

            titleLabel.centerXAnchor.constraint(equalTo: titleBar.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: titleBar.centerYAnchor),

            chevButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
            chevButton.centerYAnchor.constraint(equalTo: titleBar.centerYAnchor),
            chevButton.widthAnchor.constraint(equalToConstant: 18),
            chevButton.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}

// MARK: Collection View

extension SelectDeckPopupView: UICollectionViewDelegate, UICollectionViewDataSource,
                                UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: deckCV.frame.width/1.5, height: deckCV.frame.width/3)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeckCell", for: indexPath) as? DeckCVCell
//        cell?.cellBacking.isHidden = false
        cellDelegate?.editDeck(decks[indexPath.row])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return decks.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeckCell", for: indexPath) as? DeckCVCell
        //cell?.deckName.text = decks[indexPath.row].name
        cell?.deck = decks[indexPath.row]
        cell?.backgroundColor = .systemGray2
        cell?.layer.cornerRadius = 15
        cell?.contentView.layer.cornerRadius = 15
        return cell ?? DeckCVCell()
    }
}
