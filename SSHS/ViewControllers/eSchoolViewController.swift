//
//  eSchoolViewController.swift
//  SSHS
//
//  Created by Carlos Hernandez on 2/9/20.
//  Copyright © 2020 Student Portal. All rights reserved.
//

import UIKit
import WebKit

class eSchoolViewController: UIViewController {

    @IBOutlet weak var eSchoolView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = URLRequest(url: URL(string: "https://hac40.esp.k12.ar.us/HomeAccess40/Account/LogOn?ReturnUrl=%2FHomeAccess40")!)
                    eSchoolView.load(request)
        // Do any additional setup after loading the view.
    }
}
