//
//  AddCardViewController.swift
//  Flashcard
//
//  Created by Savill Khemraj on 2019-08-12.
//  Copyright © 2019 Savill Khemraj. All rights reserved.
//

import UIKit

protocol AddNewCard {
    func addNewCard(_ question: String, _ answer: String)
}

class AddCardViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var questionOutlet: UITextView!
    
    @IBOutlet weak var answerOutlet: UITextView!
    
    var delegate: AddNewCard?
    
    var keyboardHeight: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        questionOutlet.delegate = (self as UITextViewDelegate)
        answerOutlet.delegate = (self as UITextViewDelegate)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        
        //Create listeners
        /*NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)*/
    }
    /*
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }*/
    
    //Hide keyboard on return key
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            view.frame.origin.y = 0
            textView.resignFirstResponder()
            
            return false
        }
        return true
    }
    
    //Adjust textView if keyboard is blocking
   /* @objc func keyboardWillChange(notification: Notification) {
        guard let keyboardDimensions = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
            }
        
        if notification.name == NSNotification.Name.UIKeyboardWillShow || notification.name == NSNotification.Name.UIKeyboardWillChangeFrame {
            print("\(currentTextView?.frame.minY) \(keyboardDimensions.height)")
            if (currentTextView?.frame.minY)! > keyboardDimensions.height {
                view.frame.origin.y = -keyboardDimensions.height
            }
            else {
                view.frame.origin.y = 0
            }
        }
        else {
            view.frame.origin.y = 0
        }
    }*/
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = Int(keyboardSize.height)
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == answerOutlet {
            view.frame.origin.y = -CGFloat(keyboardHeight)  + CGFloat(50)
        }
        else {
            view.frame.origin.y = 0
        }
    }
    
    //Adds card to data model and returns to previous vc if info is filled in correctly
    @IBAction func add(_ sender: Any) {
        if !questionOutlet.text.isEmpty && !answerOutlet.text.isEmpty {
            delegate?.addNewCard(questionOutlet.text!, answerOutlet.text!)
            navigationController?.popViewController(animated: true)
        }
    }
}

