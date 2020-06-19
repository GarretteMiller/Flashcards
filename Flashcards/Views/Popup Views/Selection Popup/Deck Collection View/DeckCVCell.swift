//
//  deckCVCell.swift
//  Flashcards
//
//  Created by Garrett miller on 4/18/20.
//  Copyright © 2020 Garrett miller. All rights reserved.
//

import Foundation
import UIKit

class DeckCVCell: UICollectionViewCell {

    var deckName: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 24)
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

    var deck: Deck? {
        didSet {
            deckName.text = deck?.name

            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "hh:mm"
            deckDate.text = dateFormat.string(from: deck?.timeStamp ?? Date())
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        addSubview(deckName)
        addSubview(deckDate)

        NSLayoutConstraint.activate([
            deckName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            deckName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            deckName.heightAnchor.constraint(equalToConstant: 30),
            deckName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),

            deckDate.topAnchor.constraint(equalTo: deckName.bottomAnchor, constant: 15),
            deckDate.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            deckDate.heightAnchor.constraint(equalToConstant: 30),
            deckDate.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
    }

    override var isSelected: Bool {
        didSet {
            self.contentView.layer.borderWidth = isSelected ? 2 : 0
        }
    }
}
