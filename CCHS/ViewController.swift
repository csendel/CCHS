//
//  ViewController.swift
//  CCHS
//
//  Created by Connor Sendel on 5/5/15.
//  Copyright (c) 2015 Contripity. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scheduleScroller: UIScrollView!
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var usr: UITextField!
    @IBOutlet weak var id: UITextField!
    var inLogin : Bool = true;
    var inHome : Bool = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skipo(NSObject());
        
        if let u = NSUserDefaults.standardUserDefaults().valueForKey("usr") as? String{
            usr.text = u;
        }
        if let i = NSUserDefaults.standardUserDefaults().valueForKey("id") as? String{
            id.text = i;
        }
        
        handleViewSwitch("home")
        inHome = true;
  
        scroller.scrollEnabled = true;
        scroller.contentSize = CGSizeMake(scroller.frame.width, 2*scroller.frame.height);
        
        let swipeLeft = UISwipeGestureRecognizer()
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        swipeLeft.addTarget(self, action: "swipeLeft");
        self.view.addGestureRecognizer(swipeLeft);
        
        let swipeRight = UISwipeGestureRecognizer()
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        swipeRight.addTarget(self, action: "swipeRight");
        self.view.addGestureRecognizer(swipeRight);
        
        
        
        //scheduleScroller.scrollEnabled = true
        //scheduleScroller.contentSize = CGSizeMake(scheduleScroller.frame.width, scheduleScroller.frame.height * 3/2)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setValue(usr.text, forKey: "usr");
        NSUserDefaults.standardUserDefaults().setValue(id.text, forKey: "id");
        mainView.hidden = true;
        usr.resignFirstResponder()
        id.resignFirstResponder()
        inLogin = false
        
    }
    
    @IBAction func skipo(sender: AnyObject) {
        mainView.hidden = true;
        usr.resignFirstResponder()
        id.resignFirstResponder()
        inLogin = false
    }
    
    func swipeLeft(){
        println("left");
        if !inLogin{
            if(!scroller.hidden){
                if(!inHome){
                    homeView.frame = CGRectMake(homeView.frame.origin.x - scroller.frame.width, homeView.frame.origin.y, homeView.frame.width, homeView.frame.height);
                }
                scroller.hidden = true
            }
        }
    }
    
    func swipeRight(){
        print("right")
        if !inLogin{
            if(scroller.hidden){
                if(!inHome){
                    homeView.frame = CGRectMake(homeView.frame.origin.x + scroller.frame.width, homeView.frame.origin.y, homeView.frame.width, homeView.frame.height);
                }
               scroller.hidden = false
            }
        }
    }
    
    @IBAction func twitterButton(sender: AnyObject) {
        handleViewSwitch("twitter");
        inHome = true
    }
    
    @IBAction func bellButton(sender: AnyObject) {
       handleViewSwitch("bell");
       //bellScheduleView.hidden = false
    }
    
    @IBAction func homeButton(sender: AnyObject) {
        handleViewSwitch("home");
        inHome = true
        //homeView.hidden = false
    }
    
    func handleViewSwitch(str: NSString){
        inHome = false
        for view in homeView.subviews{
            view.removeFromSuperview()
        }
        let controller : UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier(str as String) as! UIViewController;
        homeView.addSubview(controller.view);
    }
}

