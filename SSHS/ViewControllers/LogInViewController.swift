//
//  LogInViewController.swift
//  SSHS
//
//  Created by Carlos Hernandez on 2/9/20.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import LocalAuthentication


class LogInViewController: UIViewController, UITextFieldDelegate {

    let mycontext:LAContext = LAContext()
    
    
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var LogInButton: UIButton!

    @IBOutlet weak var AuthButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var ErrorLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var TraditionalSignin: UIButton!
    
   
                
    func handleFaceID(){
        let context:LAContext = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil){
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To Autheticate User and Gain Access to all App Features.") { (Correct, error) in
                if Correct {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "Segue1", sender: self)
                    }
                }else{
                   print("error")
                }
            }
            
            
            
            
            
        }else{
            let alert = UIAlertController(title: "Error", message: "Device not compatible with this authetication method", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func authpressed(_ sender: Any) { handleFaceID()   }
    

    @IBAction func traditionalbutton(_ sender: Any) {
        AuthButton.isHidden = true
        EmailTextField.isHidden = false
        PasswordTextField.isHidden = false
        LogInButton.isHidden = false
        messageLabel.isHidden = false
        TraditionalSignin.isHidden = true
        
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        
        
        if mycontext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        {
            if mycontext.biometryType == .faceID {
                AuthButton.setTitle("Sign in with FaceID",for: .normal)
            } else if mycontext.biometryType == .touchID{
                AuthButton.setTitle("Sign in with TouchID",for: .normal)

            }
            
        }
        
       // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(IDViewController.keyboarddismiss))
            view.addGestureRecognizer(tap)
            EmailTextField.delegate = self
            PasswordTextField.delegate = self
        
        
    }
          func textFieldShouldReturn(_ textField: UITextField) -> Bool {
              EmailTextField.resignFirstResponder()
              PasswordTextField.resignFirstResponder()
              return true
          }
          @objc func keyboarddismiss() {
                 view.endEditing(true)
              }
    func setupElements(){
        
        Utilities.styleFilledButton(nextButton)
        Utilities.styleFilledButton(TraditionalSignin)
        Utilities.styleFilledButton(AuthButton)
        Utilities.styleFilledButton(LogInButton)
        Utilities.styleTextField(EmailTextField)
        Utilities.styleTextField(PasswordTextField)
        ErrorLabel.alpha = 0
    }
   func ValidateFields() -> String?{
    if EmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
    PasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
        let correctEmail  = EmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.validateEmail(correctEmail) == false {
            return "Please login using a @gosiloam.com E-mail."
            }
    return "Please Fill in all fields." }
    return nil
    }
    @IBAction func LogInTapped(_ sender: Any) {
        //Validate Text Fields
      let error = ValidateFields()
             if error != nil{
                 //there was an error (Show Error Message)
                ShowError(error!)
             }
             else {
                 //compile data
                 let email = EmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                 let password = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                //Authenticate User
                Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                    if error != nil {
                        self.ErrorLabel.text = error!.localizedDescription
                        self.ErrorLabel.alpha = 1
                    }
                    else{
                        //suceess signin
                  
                    self.LogInButton.isHidden = true
                        self.performSegue(withIdentifier: "Segue1", sender: self)

                    }
                }
        }
       
    }
    func ShowError(_ message:String){
           ErrorLabel.text = message
        ErrorLabel.isHidden = false
           ErrorLabel.alpha = 1
       }
}
