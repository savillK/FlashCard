//
//  DeckDetailsViewController.swift
//  Flashcard
//
//  Created by Savill Khemraj on 2019-08-10.
//  Copyright © 2019 Savill Khemraj. All rights reserved.
//

import UIKit
import CoreData

class DeckDetailsViewController: UIViewController, AddNewCard {
    
    @IBOutlet weak var cardTableContainer: UIView!
    
    @IBOutlet weak var deckNameOutlet: UILabel!
    
    @IBOutlet weak var startButtonOutlet: UIButton!
    
    var deck: Deck!
    
    var cardTableViewController: CardsTableViewController!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Round corner of button
        startButtonOutlet.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //If deck is first being created
        if self.deck == nil {
            startButtonOutlet.isEnabled = false
            addDeck()
        }
        else {
            reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Set up CardTableViewController
        if segue.identifier == "CardVC" {
            cardTableViewController = segue.destination as!  CardsTableViewController
            cardTableViewController.deck = self.deck
        }
    }

    //Returns to previous view controller
    @IBAction func home(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //Start the flash card vc
    @IBAction func start(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FlashcardDetailsVC") as? FlashCardViewController {
            if let navigator = navigationController {
                vc.deck = self.deck
                navigator.pushViewController(vc, animated: true)
            }
        }
    }
    
    //Add card to deck
    @IBAction func addCard(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddCardVC") as? AddCardViewController {
            if let navigator = navigationController {
                //set the delegate to use protocol
                vc.delegate = self
                navigator.pushViewController(vc, animated: true)
            }
        }
    }
    
    //Sets up vc with appropriate data
    func reloadData() {
        if self.deck.name.count > 12 {
            self.deckNameOutlet.text = self.deck.name.prefix(12) + "..."
        }
        else {
            self.deckNameOutlet.text = self.deck.name
        }
        cardTableViewController.deck = self.deck
        cardTableContainer.reloadInputViews()
        
        if self.deck.cardCount > 0 {
            startButtonOutlet.isEnabled = true
            startButtonOutlet.alpha = 1
        }
        else {
            startButtonOutlet.isEnabled = false
            startButtonOutlet.alpha = 0.6
        }
    }
    
    //Uses alert to get name of new deck and add to data model
    func addDeck() {
        let alert = UIAlertController(title: "New Deck", message: "Enter the name of new deck", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Enter name"
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            //Create new deck and save locally
            if let newDeckName = alert.textFields?.first?.text {
                if newDeckName.count > 0 {
                    
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                        return
                    }
                    
                    let context = appDelegate.persistentContainer.viewContext
                    
                    guard let deckEntity = NSEntityDescription.entity(forEntityName: "Deck", in: context) else {
                        fatalError("Entity description not found")
                    }
                    
                    let newDeck = Deck(entity: deckEntity, insertInto: context)
                    
                    newDeck.cardCount = 0
                    newDeck.name = newDeckName
                    newDeck.date = NSDate()
                    
                    do {
                        try context.save()
                    } catch {
                        print("Failed saving")
                    }
                    
                    //Assign deck to the new deck and reload page
                    self.deck = newDeck
                    self.reloadData()
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            //If user cancels, return them to previous vc
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true)
    }
    
    //Delegate func to save the data provided from the AddCardViewController
    func addNewCard(_ question: String, _ answer: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        guard let cardEntity = NSEntityDescription.entity(forEntityName: "Card", in: context) else {
            fatalError("Entity description not found")
        }
        
        let newCard = Card(entity: cardEntity, insertInto: context)
        
        newCard.question = question
        newCard.answer = answer
        newCard.date = NSDate()
        newCard.deck = self.deck
        self.deck.addToCards(newCard)
        
        self.deck.cardCount += 1
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
            self.deck.cardCount -= 1
        }
    }
    
    
    
}
