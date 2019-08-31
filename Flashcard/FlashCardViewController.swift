//
//  FlashCardViewController.swift
//  Flashcard
//
//  Created by Savill Khemraj on 2019-08-13.
//  Copyright © 2019 Savill Khemraj. All rights reserved.
//

import UIKit
import CoreData

class FlashCardViewController: UIViewController {

    @IBOutlet weak var deckName: UILabel!
    
    @IBOutlet weak var question: UILabel!
    
    @IBOutlet weak var answer: UILabel!
    
    @IBOutlet weak var showAnswerOutlet: UIButton!
    
    @IBOutlet weak var prevOutlet: UIButton!
    
    @IBOutlet weak var nextOutlet: UIButton!
    
    
    var cards = [Card]()
    var deck: Deck!
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Round corners for labels and button
        question.layer.masksToBounds = true
        question.layer.cornerRadius = 6
        
        answer.layer.masksToBounds = true
        answer.layer.cornerRadius = 6
        
        showAnswerOutlet.layer.cornerRadius = 10
        
        //Load deck name and set up card
        deckName.text = deck.name
        getCards()
        updateCard()
    }
    
    @IBAction func prev(_ sender: Any) {
        self.index -= 1
        updateCard()
    }
    
    @IBAction func showAnswer(_ sender: Any) {
        //Update answer text box and button label accordingly
        if showAnswerOutlet.currentTitle == "Show Answer" {
            showAnswerOutlet.setTitle("Hide Answer", for: .normal)
            answer.text = self.cards[self.index].answer
        }
        else {
            showAnswerOutlet.setTitle("Show Answer", for: .normal)
            answer.text = "?"
        }
    }
    
    @IBAction func next(_ sender: Any) {
        self.index += 1
        updateCard()
    }
    
    // Loads cards into array
    func getCards() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Card")
        
        let sort = NSSortDescriptor(key: "date", ascending: true)
        fetchReq.sortDescriptors = [sort]
        
        let predicate = NSPredicate(format: "deck = %@", self.deck)
        fetchReq.predicate = predicate
        
        do {
            if let results = try context.fetch(fetchReq) as? [Card] {
                cards = results
            }
        }
        catch {
            fatalError("Could not fetch deck list")
        }
    }
    
    
    func updateCard() {
        if self.index >= 0 && self.index < self.cards.count {
            self.prevOutlet.isEnabled = true
            self.prevOutlet.alpha = 1
            
            self.nextOutlet.isEnabled = true
            self.nextOutlet.alpha = 1
            resetCard()
        }
        //If on last card, disable next and don't reset
        if self.index == self.cards.count-1 {
            self.nextOutlet.isEnabled = false
            self.nextOutlet.alpha = 0.6
        }
        //If on first card, disable prev and don't reset
        if self.index == 0 {
            self.prevOutlet.isEnabled = false
            self.prevOutlet.alpha = 0.6
        }
        
    }
    
    //Resets values when next or prev buttons are clicked
    func resetCard() {
        question.text = self.cards[self.index].question
        answer.text = "?"
        showAnswerOutlet.setTitle("Show Answer", for: .normal)
    }
    
}
