//
//  EncoreViewController.swift
//  SSHS
//
//  Created by Carlos Hernandez on 2/9/20.
//  Copyright © 2020 Student Portal. All rights reserved.
//

import UIKit
import WebKit


class EncoreViewController: UIViewController {

    @IBOutlet weak var encoreView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = URLRequest(url: URL(string: "https://go.siloamschools.com/es/")!)
               encoreView.load(request)
        // Do any additional setup after loading the view.
    }
}
