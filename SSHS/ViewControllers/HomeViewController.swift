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
