//
//  SignUpViewController.swift
//  SSHS
//
//  Created by Carlos Hernandez on 2/9/20.
//  Copyright © 2020 Student Portal. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var FIrstNameTextField: UITextField!
    @IBOutlet weak var LastNameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var SignUpButton: UIButton!
    @IBOutlet weak var sigue: UIButton!
    @IBOutlet weak var ErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(IDViewController.keyboarddismiss))
                   view.addGestureRecognizer(tap)
                   EmailTextField.delegate = self
                   PasswordTextField.delegate = self
        FIrstNameTextField.delegate = self
        LastNameTextField.delegate = self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        EmailTextField.resignFirstResponder()
        PasswordTextField.resignFirstResponder()
        FIrstNameTextField.resignFirstResponder()
        LastNameTextField.resignFirstResponder()
        return true
    }
    @objc func keyboarddismiss() {
           view.endEditing(true)
    }
    
    func setupElements(){
        ErrorLabel.alpha = 0
        Utilities.styleFilledButton(SignUpButton)
        Utilities.styleTextField(FIrstNameTextField)
        Utilities.styleTextField(LastNameTextField)
        Utilities.styleTextField(EmailTextField)
        Utilities.styleTextField(PasswordTextField)
        Utilities.styleFilledButton(sigue)
    }
    
    //Validate Fields else return error message into UILABEL
    func ValidateFields() -> String?{
        //Check all fields are filled
        if FIrstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            LastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            EmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            PasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields. "
        }
        //Password is Secure?
        let cleanedPassword = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanedPassword) == false {
            //password not secure enough
             return "Please make sure yout password is at least 8 characters long, contains a special character and a number."
        }
        let correctEmail  = EmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.validateEmail(correctEmail) == false {
            return "Please a use a valid @gosiloam.com E-mail."
        }
        return nil
    }
    
    @IBAction func SignUpTapped(_ sender: Any) {
        //Validate Fields
        let error = ValidateFields()
        if error != nil{
            //there was an error (Show Error Message)
           ShowError(error!)
        }
        else {
            //compile data
            let firstname = FIrstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastname = LastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = EmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Create User
            Auth.auth().createUser(withEmail: email, password: password ) { (result, err) in
                if err != nil {
                    //there was an error creatin user
                    self.ShowError("Error Creating User")
                }
                else{
                     //user creating succelsfull store first and last name
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data:["firstname":firstname,"lastname":lastname, "uid":result!.user.uid])
                    { (error) in if error != nil {
                        self.ShowError("Error saving user data")
                        }
                    }
                  //transition home screen
                    self.TransitiontoHome()
                }
            }
        //Transition to Home Screen
        }
    }//End signUp Tapped Button
    
   
    func ShowError(_ message:String){
        ErrorLabel.text = message
        ErrorLabel.alpha = 1
    }
    func  TransitiontoHome() {
                              self.performSegue(withIdentifier: "Seguir", sender: self)

    }
}

