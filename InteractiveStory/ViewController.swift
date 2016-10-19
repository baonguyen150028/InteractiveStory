//
//  ViewController.swift
//  InteractiveStory
//
//  Created by The Bao on 10/18/16.
//  Copyright © 2016 The Bao. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    enum ErrorType: Error {
        case NoName
    }
    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet var textFieldBottomConstraint: NSLayoutConstraint!
    var constraintTemp: CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        constraintTemp = textFieldBottomConstraint.constant
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startAdventure" {
            do {
                if let name = nameTextField.text {
                    if name == "" {
                        throw ErrorType.NoName
                    }
                }
                if let pageController = segue.destination as? PageController {
                    pageController.page = Adventure.story
                }
            }catch ErrorType.NoName{
                let alertController = UIAlertController(title: "Name not Provided", message: "Provide a name to start story", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(action)
                present(alertController, animated: true, completion: nil)
            }catch let error {
                fatalError("\(error)")
            }
        }
    }
    func keyboardWillShow(notification: NSNotification){
        if let userInfoDict = notification.userInfo, let keyboardFrameValue = userInfoDict[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = keyboardFrameValue.cgRectValue

            UIView.animate(withDuration: 0.8){
                self.textFieldBottomConstraint.constant = keyboardFrame.height + 10
                self.view.layoutIfNeeded()
            }
        }
    }
    func keyboardWillHide(notification: NSNotification){
        UIView.animate(withDuration: 0.8){
            self.textFieldBottomConstraint.constant = self.constraintTemp
            self.view.layoutIfNeeded()
        }
    }
    // MARK UITextFieldDelegate 

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


}

