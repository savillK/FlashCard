//
//  ContainerViewController.swift
//  Flashcard
//
//  Created by Savill Khemraj on 2019-07-14.
//  Copyright © 2019 Savill Khemraj. All rights reserved.
//

import UIKit
import CoreData

class ContainerViewController: UIViewController {

    @IBOutlet weak var container: UIView!
    var deckTableViewController: DeckTableViewController!
    var deckDetailsVC: DeckDetailsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FlashcardVC" {
            deckTableViewController = (segue.destination as! UINavigationController).childViewControllers.first as! DeckTableViewController
        }
        else if segue.identifier == "addDeck" {
            deckDetailsVC = (segue.destination as!  UINavigationController).childViewControllers.first as! DeckDetailsViewController
            deckDetailsVC.deck = nil
        }
    }
    
    //Segue to DeckDetailsViewController to add a new deck
    @IBAction func addDeckButton(_ sender: Any) {
        performSegue(withIdentifier: "addDeck", sender: self)
    }

}
