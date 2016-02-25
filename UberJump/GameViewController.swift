//
//  GameViewController.swift
//  UberJump
//
//  Created by Alexander Frolov on 04/02/15.
//  Copyright (c) 2015 Alexander Frolov. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds
//import AVFoundation


class GameViewController: UIViewController, GADBannerViewDelegate  {

    
    
    @IBAction func SettingClick(sender: AnyObject) {
        let barsLink : String = "itms-apps://itunes.apple.com/ca/artist/phuong-nguyen/id1004963752"
        UIApplication.sharedApplication().openURL(NSURL(string: barsLink)!)    }
    
    @IBAction func MoreAppDrag(sender: AnyObject) {
        Utility.OpenView("AdView1", view: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = view as! SKView
        
        let scene = GameScene(size: skView.bounds.size)
        
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
       
        let myAd = MyAd(root: self)
        
        myAd.ViewDidload()
        
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

 
   }
