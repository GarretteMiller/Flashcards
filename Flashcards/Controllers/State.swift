//
//  State.swift
//  Flashcards
//
//  Created by Garrett miller on 4/19/20.
//  Copyright © 2020 Garrett miller. All rights reserved.
//

import UIKit

enum State {
    case closed
    case editing
}

extension State {
    var next: State {
        switch self {
        case .closed: return .editing
        case .editing: return .closed
        }
    }
}
