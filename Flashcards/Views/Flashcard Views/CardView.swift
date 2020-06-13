//
//  cardView.swift
//  Flashcards
//
//  Created by Garrett miller on 4/15/20.
//  Copyright © 2020 Garrett miller. All rights reserved.
//

import UIKit

class CardView: UIView {

    var cardFront: CardModel?
    var cardBack: CardModel?

    init(cardFront: CardModel, cardBack: CardModel) {
        self.cardFront = cardFront
        self.cardBack = cardBack
        super.init(frame: CGRect(x: 0, y: 0, width: 350, height: 210))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
