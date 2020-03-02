//
//  WelcomeViewController.swift
//  SSHS
//
//  Created by Carlos Hernandez on 2/9/20.
//  Copyright © 2020 Student Portal. All rights reserved.
//

import UIKit
import UserNotifications
import LocalAuthentication

class WelcomeViewController: UIViewController {
    @IBOutlet weak var Encore: UIButton!
    @IBOutlet weak var eSchool: UIButton!
    @IBOutlet weak var myID: UIButton!
    @IBOutlet weak var SegmentBar: UISegmentedControl!
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var myStack: UIStackView!
    
    let mycontext = LAContext()
    
    let defaults = UserDefaults.standard
    var NotifsEnabled = false
    
    struct Keys {
        static let notifsEnabled = "prendida"
    }
    
    @IBAction func BarChanged(_ sender: Any) {
        NotifsEnabled = (sender as AnyObject).selectedSegmentIndex == 1
        saveStylePreferences()
        switch  SegmentBar.selectedSegmentIndex {
        case 1:
                
            Label.text = "Notifications Enabled!"
            
            // create the alert
                      let alert = UIAlertController(title: "Success!", message: "Notifications have been set to remind you to check your RTI on wednesdays", preferredStyle: UIAlertController.Style.alert)

                      // add an action (button)
                      alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                      

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
            let alert = UIAlertController(title: "Alert", message: "Notifications have been disabled please make sure to turn them back for a more enjoyable experience!", preferredStyle: UIAlertController.Style.alert)

            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

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
          if mycontext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
          {
              if mycontext.biometryType == .faceID {
                myStack.spacing = 70
              } else if mycontext.biometryType == .touchID{
                myStack.spacing = 30
              }
          }
    }
   
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           whatsNewIfNeeded()
       }
       
       func whatsNewIfNeeded(){
           
        let items = [WhatsNew.Item(title: "FaceID", subtitle: "Added FaceID authentication", image: UIImage(named: "faceidglyph")),WhatsNew.Item(title: "IDView", subtitle: "Access your ID within the app", image: UIImage(named: "as")), WhatsNew.Item(title: "EncoreViewer", subtitle: "Access you EncoreViewer within the app.", image: UIImage(named: "worldglyph")), WhatsNew.Item(title: "eSchool", subtitle: "Access your grades within the app.", image: UIImage(named: "aplus"))]
        
        let theme = WhatsNewViewController.Theme{ configuration in
            configuration.apply(animation: .fade)
           configuration.backgroundColor = UIColor.init(red: 31/255, green: 33/255, blue: 36/255, alpha: 1)
            configuration.titleView.titleColor = .white
            configuration.itemsView.titleColor = .white
            configuration.itemsView.subtitleColor = .lightGray
            configuration.completionButton.backgroundColor = UIColor.init(red: 80/255, green: 0/255, blue: 19/255, alpha: 1)
            }
        
           let config = WhatsNewViewController.Configuration(theme: theme)
        
           let whatsNew = WhatsNew(title: "Welcome to Panther Portal", items: items)
           
        let keyValueVersionStore = KeyValueWhatsNewVersionStore(keyValueable: UserDefaults.standard, prefixIdentifier: "test")
        
           let whatsNewVC = WhatsNewViewController(whatsNew: whatsNew, configuration: config, versionStore: keyValueVersionStore)
        
        if let vc = whatsNewVC {
            self.present(vc, animated: true, completion: nil)
        }
        else {
            print("No ViewController to present")
        }
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
