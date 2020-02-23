//
//  WelcomeViewController.swift
//  SSHS
//
//  Created by Carlos Hernandez on 2/9/20.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit
import UserNotifications
import SafariServices

class WelcomeViewController: UIViewController {
    @IBOutlet weak var Encore: UIButton!
    @IBOutlet weak var eSchool: UIButton!
    @IBOutlet weak var myID: UIButton!
    @IBOutlet weak var SegmentBar: UISegmentedControl!
    @IBOutlet weak var Label: UILabel!
    
    
    
    let defaults = UserDefaults.standard
    var NotifsEnabled = false
    
    struct Keys {
        static let notifsEnabled = "prendida"
    }
    
    
    
    @IBAction func ecnore(_ sender: Any) {
        /*
        guard let url = URL(string: "https://go.siloamschools.com/es/")
                 
                 else {
                     return
             }
             let safariVC = SFSafariViewController(url: url)
             safariVC.preferredBarTintColor = .black
             safariVC.preferredControlTintColor = .white
             present(safariVC, animated: true)
        */
        
    }
    
    @IBAction func encore(_ sender: Any) {
  /*  guard let url = URL(string: "https://hac40.esp.k12.ar.us/HomeAccess40/Account/LogOn?ReturnUrl=%2FHomeAccess40")
             
             else {
                 return
         }
         let safariVC2 = SFSafariViewController(url: url)
         safariVC2.preferredBarTintColor = .black
         safariVC2.preferredControlTintColor = .white
         present(safariVC2, animated: true)
    
    */
    }
   
    
    @IBAction func BarChanged(_ sender: Any) {
        NotifsEnabled = (sender as AnyObject).selectedSegmentIndex == 1
        saveStylePreferences()
        switch  SegmentBar.selectedSegmentIndex {
        case 1:
           
            
            Label.text = "Notifications Enabled!"
            
            
            
            
            // create the alert
                      let alert = UIAlertController(title: "Alert", message: "Notifications have been enabled :))))))", preferredStyle: UIAlertController.Style.alert)

                      // add an action (button)
                      alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                      alert.addAction(UIAlertAction(title: "OK (but in bold)", style: UIAlertAction.Style.cancel, handler: nil))
                      alert.addAction(UIAlertAction(title: "OK (but in red)", style: UIAlertAction.Style.destructive, handler: nil))

                      // show the alert
                      self.present(alert, animated: true, completion: nil)
            
            
            
            
            
            
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = "Remember to check your EncoreViewer"
            var dateComponents = DateComponents()
            dateComponents.calendar = Calendar.current
            dateComponents.weekday = 4 // 4
            dateComponents.hour = 8  // 8
            dateComponents.minute = 15 //15
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger )
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request) {(error) in
                if error != nil {
                    print("Error")
                }
                else {
                   
                    print("Alert Set Up")
                }
            }
            
    
            
        case 0:
            Label.text = "Notifications Disabled!"

            print("Alerts Cancelled")
           
            // create the alert
            let alert = UIAlertController(title: "Alert", message: "Notifications have been disabled :(", preferredStyle: UIAlertController.Style.alert)

            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            alert.addAction(UIAlertAction(title: "OK (but in bold)", style: UIAlertAction.Style.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "OK (but in red)", style: UIAlertAction.Style.destructive, handler: nil))

            // show the alert
            self.present(alert, animated: true, completion: nil)
        
        default:
            break;
        }

        }
    
override func viewDidLoad() {
        super.viewDidLoad()
        CheckForStylePrefs()
        Utilities.styleFilledButton(Encore)
        Utilities.styleFilledButton(eSchool)
        Utilities.styleFilledButton(myID)
        // Do any additional setup after loading the view.
        
    }
    
    
    
    func saveStylePreferences() {
        
        defaults.set(NotifsEnabled, forKey: Keys.notifsEnabled)
        
    }
    
    func CheckForStylePrefs(){
        let prendidas = defaults.bool(forKey: Keys.notifsEnabled)
        if prendidas {
            NotifsEnabled = true
            SegmentBar.selectedSegmentIndex = 1
            Label.text = "Notifications Enabled!"
            
        } else{
            Label.text = "Notifications Disabled!"
            
        }
    }

}
