//
//  welcomeView.swift
//  CCHS
//
//  Created by Student on 2015-05-08.
//  Copyright (c) 2015 Contripity. All rights reserved.
//

import UIKit

class welcomeView: UIViewController {

    @IBOutlet weak var powerSchoolView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let urlStr = "https://powerschool.cherrycreekschools.org/guardian/home.html"
        let url = NSURL(string: urlStr)!
        let req = NSURLRequest(URL: url)
        powerSchoolView.loadRequest(req)
        
        print("loaded url")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
