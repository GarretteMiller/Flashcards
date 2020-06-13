//
//  Deck+CoreDataProperties.swift
//  Flashcards
//
//  Created by Garrett miller on 5/1/20.
//  Copyright © 2020 Garrett miller. All rights reserved.
//
//

import Foundation
import CoreData

extension Deck {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Deck> {
        return NSFetchRequest<Deck>(entityName: "Deck")
    }

    @NSManaged public var name: String?
    @NSManaged public var contains: Set<Card>
    @NSManaged public var timeStamp: Date
}

// MARK: Generated accessors for contains
extension Deck {

    @objc(addContainsObject:)
    @NSManaged public func addToContains(_ value: Card)

    @objc(removeContainsObject:)
    @NSManaged public func removeFromContains(_ value: Card)

    @objc(addContains:)
    @NSManaged public func addToContains(_ values: NSSet)

    @objc(removeContains:)
    @NSManaged public func removeFromContains(_ values: NSSet)

}
