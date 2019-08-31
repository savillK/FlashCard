//
//  Card+CoreDataProperties.swift
//  Flashcard
//
//  Created by Savill Khemraj on 2019-08-06.
//  Copyright © 2019 Savill Khemraj. All rights reserved.
//
//

import Foundation
import CoreData


extension Card {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card")
    }

    @NSManaged public var answer: String
    @NSManaged public var date: NSDate
    @NSManaged public var question: String
    @NSManaged public var deck: Deck

}
