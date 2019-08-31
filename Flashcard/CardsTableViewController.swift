//
//  DeckDetailsTableViewController.swift
//  Flashcard
//
//  Created by Savill Khemraj on 2019-08-10.
//  Copyright © 2019 Savill Khemraj. All rights reserved.
//

import UIKit
import CoreData

class CardsTableViewController: UITableViewController {
    
    
    @IBOutlet var CardTableViewOutlet: UITableView!
    
    var cards = [Card]()
    var deck: Deck!

    override func viewDidLoad() {
        super.viewDidLoad()

        reloadData()
        CardTableViewOutlet.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Everytime a card is added in another page, this table will update accordingly
        reloadData()
        CardTableViewOutlet.reloadData()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath)
        
        cell.textLabel?.text = cards[indexPath.row].question
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Deselect row so it doesn't stay highlighted
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        //Navigate to ViewCardViewController
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewCardVC") as? ViewCardViewController {
            if let navigator = navigationController {
                vc.card = cards[indexPath.row]
                navigator.pushViewController(vc, animated: true)
            }
        }
    }
    
    //Creates a quicker and more convenient way of deleting decks
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle != .delete {return}
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let card = cards[indexPath.row]
        card.deck.cardCount -= 1
        context.delete(card)
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
            card.deck.cardCount += 1
        }
        
        reloadData()
    }
    
    //Loads appropriate data into card array
    func reloadData() {
        if self.deck != nil {
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
                    self.CardTableViewOutlet.reloadData()
                }
            }
            catch {
                fatalError("Could not fetch deck list")
            }
        }
    }


}
