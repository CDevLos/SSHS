//
//  HomeViewController.swift
//  SSHS
//
//  Created by Carlos Hernandez on 2/9/20.
//  Copyright © 2020 Student Portal. All rights reserved.
//

import UIKit
import AVFoundation
import SafariServices

class HomeViewController: UIViewController {

    var videoPlayer: AVPlayer?
    var videoplayerlayer: AVPlayerLayer?
    @IBOutlet weak var LogInButton: UIButton!
    @IBOutlet weak var SignInButton: UIButton!
    @IBOutlet weak var vid: UIView!
    @IBOutlet weak var stack: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        setupVideo()
    }
    
override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    whatsNewIfNeeded()
    }
    
    
    func whatsNewIfNeeded(){
        let items = [WhatsNew.Item(title: "Login with Email", subtitle: "Create a new account with your school email and password.", image: UIImage(named: "key")), WhatsNew.Item(title: "FaceID", subtitle: "Log in with FaceID for quicker access.", image: UIImage(named: "faceidglyph")), WhatsNew.Item(title: "IDView", subtitle: "Access your ID within the app", image: UIImage(named: "as")), WhatsNew.Item(title: "EncoreViewer", subtitle: "Access you 3EncoreViewer within the app.", image: UIImage(named: "worldglyph")), WhatsNew.Item(title: "eSchool", subtitle: "Access your grades within the app.", image: UIImage(named: "aplus"))]
               
               let theme = WhatsNewViewController.Theme{ configuration in
                   configuration.apply(animation: .fade)
                   configuration.backgroundColor = UIColor.init(red: 31/255, green: 33/255, blue: 36/255, alpha: 1)
                   configuration.titleView.titleColor = .white
                   configuration.itemsView.titleColor = .white
                   configuration.itemsView.subtitleColor = .lightGray
                   configuration.completionButton.backgroundColor = UIColor.init(red: 80/255, green: 0/255, blue: 19/255, alpha: 1)
                //   configuration.itemsView.contentMode = .center
                   }
               
                  let config = WhatsNewViewController.Configuration(theme: theme)
               
                  let whatsNew = WhatsNew(title: "Welcome to Panther Portal", items: items)
                  
               let keyValueVersionStore = KeyValueWhatsNewVersionStore(keyValueable: UserDefaults.standard, prefixIdentifier: "test")
               
                  let whatsNewVC = WhatsNewViewController(whatsNew: whatsNew, configuration: config, versionStore: keyValueVersionStore)
               
               if let vc2 = whatsNewVC {
                   self.present(vc2, animated: true, completion: nil)
               }
               else {
                   print("No ViewController to present")
               }
        
        
        
    }
    
    
    
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?)
 {  UIView.animate(withDuration: 0.4){
    
    self.showSafariVC()
    }   }
  
    func showSafariVC(){
        guard let url = URL(string: "https://go.siloamschools.com/es/")
            
            else {
                return
        }
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredBarTintColor = .black
        safariVC.preferredControlTintColor = .white
        present(safariVC, animated: true)
    }
    
    func setupElements(){
        Utilities.styleFilledButton(LogInButton)
        Utilities.styleFilledButton(SignInButton)
    }

    func setupVideo(){
        //Experimental Check on real device when time permits.. :((
        let audioSession = AVAudioSession.sharedInstance()
        if audioSession.isOtherAudioPlaying {
            _ = try? audioSession.setCategory(AVAudioSession.Category.ambient, options: AVAudioSession.CategoryOptions.mixWithOthers)
        } // end of experimental code :))
        
      let bundlePath = Bundle.main.path(forResource: "introvideo", ofType: "mp4")
        guard bundlePath != nil else {
            return
        }
        let url = URL(fileURLWithPath: bundlePath!)
        let item = AVPlayerItem(url: url)
        videoPlayer = AVPlayer(playerItem: item)
        videoplayerlayer = AVPlayerLayer(player: videoPlayer!)
        videoplayerlayer?.frame = self.view.bounds
        videoplayerlayer?.videoGravity = .resizeAspectFill
        self.vid.layer.addSublayer((videoplayerlayer)!)
        videoPlayer?.play()
        vid.bringSubviewToFront(stack)
    }
    
}
