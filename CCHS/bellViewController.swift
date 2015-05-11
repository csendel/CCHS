//
//  bellViewController.swift
//  CCHS
//
//  Created by Student on 2015-05-11.
//  Copyright (c) 2015 Contripity. All rights reserved.
//

import UIKit

class bellViewController: UIViewController {

    @IBOutlet weak var scroller: UIScrollView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        scroller.contentSize = CGSizeMake(scroller.frame.width, 4 * scroller.frame.height / 3)

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
