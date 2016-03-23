//
//  DetailViewController.swift
//  Rsreader
//
//  Created by hoseen on 3/19/16.
//  Copyright © 2016 hoseen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
   
    var currentArticle : Article?
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string :currentArticle!.url)
        let urlReq = NSURLRequest(URL: url!)
        self.webview.loadRequest(urlReq)
        


    }
    

    @IBOutlet weak var webview: UIWebView!
}
