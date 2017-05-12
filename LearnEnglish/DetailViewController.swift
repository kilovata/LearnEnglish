//
//  DetailViewController.swift
//  LearnEnglish
//
//  Created by kilovata on 5/12/17.
//  Copyright © 2017 Kilovata. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController
{
    @IBOutlet weak var web: UIWebView!
    var titleScreen: String = ""
    var link: String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem?.title = ""
        navigationItem.leftBarButtonItem?.title = ""
        title = titleScreen
        
        if let url = URL(string: link)
        {
            let request = URLRequest(url: url)
            web.loadRequest(request)
        }
    }
}
