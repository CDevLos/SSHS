//
//  ReportViewController.swift
//  SSHS
//
//  Created by Carlos Hernandez on 2/19/20.
//  Copyright © 2020 Student Portal. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI
import UserNotifications


class ReportViewController: UIViewController {

    
    @IBOutlet weak var newfeats: UIButton!
    @IBOutlet weak var bugs: UIButton!
    @IBOutlet weak var misuse: UIButton!


    @IBAction func newfeatures (_ sender: Any) {
        showmailview1()
    }
    
    @IBAction func ReportBugs(_ sender: Any) {
        showmailview2()
    }
    
    @IBAction func encore(_ sender: Any) {
        showmailview3()
    }
   //end of IBActions
    func showmailview1(){
        guard MFMailComposeViewController.canSendMail()
            else {
                //sasdad
                return
        }
    let composer = MFMailComposeViewController()
    composer.mailComposeDelegate = self
    composer.setToRecipients(["assistsshsapp@gmail.com"])
    composer.setSubject("New feature suggestion")
        composer.setMessageBody("[insert suggestion]", isHTML: false)
        present(composer, animated: true)
        
        
    }// end of 1
 
    func showmailview2(){
         
        guard MFMailComposeViewController.canSendMail()
                   else {
                       //sasdad
                       return
               }
           let composer = MFMailComposeViewController()
           composer.mailComposeDelegate = self
           composer.setToRecipients(["assistsshsapp@gmail.com"])
           composer.setSubject("Bug Report")
               composer.setMessageBody("Bug found on [insert date]...", isHTML: false)
               present(composer, animated: true)
               
        
    }// end of 2
   
    func showmailview3(){
        guard MFMailComposeViewController.canSendMail()
                   else {
                       //sasdad
                       return
               }
           let composer = MFMailComposeViewController()
           composer.mailComposeDelegate = self
           composer.setToRecipients(["assistsshsapp@gmail.com"])
           composer.setSubject("Suspected Misuse")
               composer.setMessageBody("Describe the believed misuse. Use as much detail as possible. All messages are confidential.", isHTML: false)
               present(composer, animated: true)
               
         
    }// end of 3

    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleFilledButton(newfeats)
        Utilities.styleFilledButton(bugs)
        Utilities.styleFilledButton(misuse)

        // Do any additional setup after loading the view.
    }
    

}

extension ReportViewController: MFMailComposeViewControllerDelegate{
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            controller.dismiss(animated: true, completion: nil)
            return
        }
        switch result {
        case .cancelled:
            let alert = UIAlertController(title: "Done", message: "Please consider sending a report we value your feedback", preferredStyle: UIAlertController.Style.alert)

                                // add an action (button)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                               

                                // show the alert
                                self.present(alert, animated: true, completion: nil)
                       print("Cancelled")
            
            controller.dismiss(animated: true, completion: nil)

        case .failed:
            
                       print("Failed")
            
            controller.dismiss(animated: true, completion: nil)
                       let alert = UIAlertController(title: "Error", message: "There was an unknown error.", preferredStyle: UIAlertController.Style.alert)
                       
                       // add an action (button)
                       alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                      
                    // show the alert
                       self.present(alert, animated: true, completion: nil)
        case .saved:
            
                       print("Saved")
            
            controller.dismiss(animated: true, completion: nil)
                       let alert = UIAlertController(title: "Message Saved", message: "Email draft has been saved!", preferredStyle: UIAlertController.Style.alert)
                       
                       // add an action (button)
                       alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                       
                       // show the alert
                       self.present(alert, animated: true, completion: nil)

        case .sent:
            
            print("Sucess")
            controller.dismiss(animated: true, completion: nil)
            let alert = UIAlertController(title: "Success!", message: "Message Sent: We value your feedback, thank you for allowing us to provide the best user experience!", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
         
            
        @unknown default:
            fatalError()
        }
        
        
    }
    
    
}
