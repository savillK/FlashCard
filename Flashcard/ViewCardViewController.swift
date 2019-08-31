//
//  ViewCardViewController.swift
//  Flashcard
//
//  Created by Savill Khemraj on 2019-08-13.
//  Copyright © 2019 Savill Khemraj. All rights reserved.
//

import UIKit

class ViewCardViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var questionOutlet: UITextView!
    
    @IBOutlet weak var answerOutlet: UITextView!
    
    var card: Card!
    
    var currentTextView: UITextView?
    
    var keyboardHeight: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentTextView = questionOutlet
        
        questionOutlet.delegate = (self as UITextViewDelegate)
        answerOutlet.delegate = (self as UITextViewDelegate)

        questionOutlet.text = card.question
        answerOutlet.text = card.answer
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        card.question = questionOutlet.text
        card.answer = answerOutlet.text
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            view.frame.origin.y = 0
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = Int(keyboardSize.height)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == answerOutlet {
            view.frame.origin.y = -CGFloat(keyboardHeight) + CGFloat(50)
        }
        else {
            view.frame.origin.y = 0
        }
        currentTextView = textView
    }
    
}
