//
//  Card+CoreDataProperties.swift
//  Flashcards
//
//  Created by Garrett miller on 5/1/20.
//  Copyright © 2020 Garrett miller. All rights reserved.
//
//

import Foundation
import CoreData

extension Card {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card")
    }

    @NSManaged public var frontText: String?
    @NSManaged public var backText: String?

}
