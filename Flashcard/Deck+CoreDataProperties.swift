//
//  Deck+CoreDataProperties.swift
//  Flashcard
//
//  Created by Savill Khemraj on 2019-08-06.
//  Copyright © 2019 Savill Khemraj. All rights reserved.
//
//

import Foundation
import CoreData


extension Deck {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Deck> {
        return NSFetchRequest<Deck>(entityName: "Deck")
    }

    @NSManaged public var cardCount: Int64
    @NSManaged public var date: NSDate
    @NSManaged public var name: String
    @NSManaged public var topic: String?
    @NSManaged public var cards: NSSet?

}

// MARK: Generated accessors for cards
extension Deck {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: Card)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: Card)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}
