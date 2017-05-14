//
//  DetailViewController.swift
//  LearnEnglish
//
//  Created by kilovata on 5/12/17.
//  Copyright © 2017 Kilovata. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController, UIWebViewDelegate
{
    @IBOutlet weak var web: UIWebView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var titleScreen: String = ""
    var link: String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = titleScreen
        
        if let url = URL(string: link)
        {
            let request = URLRequest(url: url)
            web.loadRequest(request)
        }
    }
    
    public func webViewDidStartLoad(_ webView: UIWebView)
    {
        indicator.startAnimating()
    }

    public func webViewDidFinishLoad(_ webView: UIWebView)
    {
        indicator.stopAnimating()
    }
}
