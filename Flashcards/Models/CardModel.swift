//
//  Card.swift
//  Flashcards
//
//  Created by Garrett miller on 4/15/20.
//  Copyright © 2020 Garrett miller. All rights reserved.
//

import UIKit

class CardModel: UIView {
    var text: String!

    init(text: String) {
        self.text = text
        super.init(frame: CGRect(x: 0, y: 0, width: 350, height: 210))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
