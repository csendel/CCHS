//
//  ViewController.swift
//  CCHS
//
//  Created by Connor Sendel on 5/5/15.
//  Copyright (c) 2015 Contripity. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usr: UITextField!
    @IBOutlet weak var id: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let u = NSUserDefaults.standardUserDefaults().valueForKey("usr") as? String{
            usr.text = u;
        }
        if let i = NSUserDefaults.standardUserDefaults().valueForKey("id") as? String{
            id.text = i;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setValue(usr.text, forKey: "usr");
        NSUserDefaults.standardUserDefaults().setValue(id.text, forKey: "id");
    }
}

