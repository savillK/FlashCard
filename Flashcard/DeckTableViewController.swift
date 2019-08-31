//
//  DeckTableViewController.swift
//  Flashcard
//
//  Created by Savill Khemraj on 2019-06-25.
//  Copyright © 2019 Savill Khemraj. All rights reserved.
//

import UIKit
import CoreData


class DeckTableViewController: UITableViewController {

    @IBOutlet var tableViewOutlet: UITableView!
    
    var deckData = [Deck]()
    
    var selectedDeckId: Int64 = 0
    
    var deckDetailsVC: DeckDetailsViewController!
    
    // MARK: - Table view data source
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadData()
        tableViewOutlet.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadData()
        tableViewOutlet.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deckData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeckCell", for: indexPath)

        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = deckData[indexPath.row].name
        cell.detailTextLabel?.text = "\(deckData[indexPath.row].cardCount)" + " cards"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Deselect highlighted row
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        //Move to DeckDetailsViewController
        performSegue(withIdentifier: "ViewDeck", sender: self)
        deckDetailsVC.deck = deckData[indexPath.row]
        
    }
    
    //Creates a quicker and more convenient way of deleting decks
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle != .delete {return}
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let deck = deckData[indexPath.row]
        context.delete(deck)
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
        
        reloadData()
    }
    
    //Retrieve decks from data model and load table with values
    func reloadData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Deck")
        
        let sort = NSSortDescriptor(key: "date", ascending: true)
        fetchReq.sortDescriptors = [sort]
        
        do {
            if let results = try context.fetch(fetchReq) as? [Deck] {
                deckData = results
                self.tableViewOutlet.reloadData()
            }
        }
        catch {
            fatalError("Could not fetch deck list")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewDeck" {
            deckDetailsVC = (segue.destination as! UINavigationController).childViewControllers.first as! DeckDetailsViewController
        }
    }


}
