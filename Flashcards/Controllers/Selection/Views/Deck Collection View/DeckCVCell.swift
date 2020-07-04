//
//  deckCVCell.swift
//  Flashcards
//
//  Created by Garrett miller on 4/18/20.
//  Copyright © 2020 Garrett miller. All rights reserved.
//

import Foundation
import UIKit

protocol DeckCVCellDelegate: class {
    func editDeck(_ deck: Deck)
    func playDeck(_ deck: Deck)
    func deleteDeck(_ deck: Deck)
}

class DeckCVCell: UICollectionViewCell {

    var deckName: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var deckDate: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pencil")?
            .withTintColor(.black, renderingMode: .alwaysOriginal), for: .init())
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill")?
            .withTintColor(.black, renderingMode: .alwaysOriginal), for: .init())
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash")?
            .withTintColor(.black, renderingMode: .alwaysOriginal), for: .init())
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var deck: Deck? {
        didSet {
            deckName.text = deck?.name

            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "MM/dd hh:mm"
            deckDate.text = dateFormat.string(from: deck?.timeStamp ?? Date())
        }
    }

    weak var cellDelegate: DeckCVCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        editButton.addTarget(self, action: #selector(tappedEdit), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(tappedPlay), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(tappedDelete), for: .touchUpInside)

        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        addSubview(deckName)
        addSubview(deckDate)
        addSubview(editButton)
        addSubview(playButton)
        addSubview(deleteButton)

        NSLayoutConstraint.activate([
            editButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            editButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            editButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            editButton.widthAnchor.constraint(equalToConstant: 40),

            deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            deleteButton.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            deleteButton.widthAnchor.constraint(equalToConstant: 40),

            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playButton.trailingAnchor.constraint(equalTo: editButton.leadingAnchor),
            playButton.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 40),

            deckName.centerYAnchor.constraint(equalTo: editButton.centerYAnchor),
            deckName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            deckName.heightAnchor.constraint(equalToConstant: 30),
            deckName.trailingAnchor.constraint(equalTo: playButton.leadingAnchor),

            deckDate.centerYAnchor.constraint(equalTo: deleteButton.centerYAnchor),
            deckDate.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            deckDate.heightAnchor.constraint(equalToConstant: 30),
            deckDate.trailingAnchor.constraint(equalTo: playButton.leadingAnchor)
        ])
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard isUserInteractionEnabled else { return nil }
        guard !isHidden else { return nil }
        guard alpha >= 0.01 else { return nil }
        guard self.point(inside: point, with: event) else { return nil }

        if self.editButton.point(inside: convert(point, to: editButton), with: event), isSelected {
            return self.editButton
        }

        if self.playButton.point(inside: convert(point, to: playButton), with: event), isSelected {
            return self.playButton
        }

        if self.deleteButton.point(inside: convert(point, to: deleteButton), with: event), isSelected {
            return self.deleteButton
        }

        return super.hitTest(point, with: event)
    }

    @objc func tappedEdit(sender: UIButton!) {
        cellDelegate?.editDeck(deck!)
    }

    @objc func tappedPlay(sender: UIButton!) {
        cellDelegate?.playDeck(deck!)
    }

    @objc func tappedDelete(sender: UIButton!) {
        cellDelegate?.deleteDeck(deck!)
    }

    override var isSelected: Bool {
        didSet {
            self.contentView.layer.borderWidth = isSelected ? 2 : 0
            //self.editButton.layer.borderWidth = isSelected ? 1 : 0
            self.playButton.layer.addBorder(edge: UIRectEdge.left, color: .black, thickness: isSelected ? 1 : 0)
            self.playButton.layer.addBorder(edge: UIRectEdge.right, color: .black, thickness: isSelected ? 1 : 0)
            self.deleteButton.layer.addBorder(edge: UIRectEdge.top, color: .black, thickness: isSelected ? 1 : 0)
            self.editButton.isHidden = isSelected ? false : true
            self.playButton.isHidden = isSelected ? false : true
            self.deleteButton.isHidden = isSelected ? false : true
        }
    }
}

extension CALayer {

    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {

        let border = CALayer()

        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness,
                                  width: UIScreen.main.bounds.width, height: thickness)
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0,
                                  width: thickness, height: self.frame.height)
        default:
            break
        }

        border.backgroundColor = color.cgColor

        self.addSublayer(border)
    }

}
