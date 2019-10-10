//
//  WkView.swift
//  TacoTracker
//
//  Created by Eric Fuentes on 1/28/19.
//  Copyright © 2019 Eric Fuentes. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class WkView: UIViewController {
    
    
    var viewController: ViewController?

    @IBOutlet weak var wkView: WKWebView!
    
    var urlString = "https://www.google.com"

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let url:URL = URL(string: urlString)!
        let urlRequest:URLRequest = URLRequest(url: url)
        wkView.load(urlRequest)
        
    }
}
