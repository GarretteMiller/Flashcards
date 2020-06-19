//
//  PersistenceService.swift
//  Flashcards
//
//  Created by Garrett miller on 5/1/20.
//  Copyright © 2020 Garrett miller. All rights reserved.
//

import Foundation
import CoreData

class PersistenceService {

    // MARK: - Core Data stack

    private init() {}
    static let shared = PersistenceService()

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Flashcards")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                //      You should not use this function in a shipping application,
                //      although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data
                        protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var context = persistentContainer.viewContext

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                //      You should not use this function in a shipping application,
                //      although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func fetch<T: NSManagedObject>(_ objectType: T.Type) -> [T] {
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)

        do {
            let fetchedObjects = try context.fetch(fetchRequest) as? [T]
            return fetchedObjects ?? [T]()
        } catch {
            print(error)
            return [T]()
        }
    }

    func fetchDecks() -> [Deck] {
        let entityName = String(describing: Deck.self)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)

        do {
            var fetchedObjects = try context.fetch(fetchRequest) as? [Deck]
            if fetchedObjects != nil {
                fetchedObjects = fetchedObjects!.sorted(by: {
                    $0.timeStamp.compare($1.timeStamp) == .orderedDescending
                })
            }
            return fetchedObjects ?? [Deck]()
        } catch {
            print(error)
            return [Deck]()
        }
    }

    func deckCount() -> Int {
        fetch(Deck.self).count
    }

    func saveDeck(deckToSave: Deck) {
        let decks = fetch(Deck.self)
        let deck = decks.first { $0.objectID == deckToSave.objectID }
        if deck != deckToSave {
            saveContext()
        }
    }

    func createDefaultDeck() {
        let deck = Deck(context: context)
        deck.name = "New\(deckCount())"
        deck.timeStamp = Date()

        let card = Card(context: context)
        card.frontText = "front"
        card.backText = "back"
        deck.addToContains(card)

        saveContext()
    }

    func createDefaultCard(objectId: NSManagedObjectID) {
        let decks = fetch(Deck.self)
        let card = Card(context: context)
        card.frontText = "front"
        card.backText = "back"

        decks.first { $0.objectID == objectId }?.addToContains(card)
    }
}
