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

class GameViewController: UIViewController, VungleSDKDelegate, GADBannerViewDelegate  {

    
    var vungleSdk = VungleSDK.sharedSDK()
    var AdNumber = 1
    var timerAd:NSTimer?
    var bannerView:GADBannerView?
    
    
    
    
    @IBOutlet weak var adView: UIView!
    
    
    @IBAction func SettingClick(sender: AnyObject) {
        adView.hidden = false
    }
    
    @IBAction func MoreAppDrag(sender: AnyObject) {
        
        
    }
    
    
    @IBAction func closeСlick(sender: AnyObject) {
         adView.hidden = true
    }
    
    @IBAction func MainAdClick(sender: AnyObject) {
        showAds()
        
    }
    
    @IBAction func AutoClick(sender: AnyObject) {
        adView.backgroundColor = UIColor.blueColor()
        
        
        self.timerAd = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "timerMethodAutoAd:", userInfo: nil, repeats: true)
    }
    
    @IBAction func mobileCoreFullClick(sender: AnyObject){
       showAds()
    
    }
    
    var interstitial: GADInterstitial!
    
    func createAndLoadAd() -> GADInterstitial
    {
        var ad = GADInterstitial(adUnitID: "ca-app-pub-9535461294868148/4372006515")
        
        var request = GADRequest()
        
        request.testDevices = [""]
        
        ad.loadRequest(request)
        
        return ad
    }
    func showAdmob()
    {
        if (self.interstitial.isReady)
        {
            self.interstitial.presentFromRootViewController(self)
            self.interstitial = self.createAndLoadAd()
        }
    }
    func showAds()
    {
        Chartboost.showInterstitial("Level " + String(AdNumber))
        AdNumber++
        println(AdNumber)
    }
    func showMobilecore()
    {
        
        MobileCore.showInterstitialFromViewController(self, delegate: nil)
    }
    func showMobilecore2()
    {
        MobileCore.showStickeeFromViewController(self)
    }
    func showAdcolony()
    {
        AdColony.playVideoAdForZone("vz52c7bc9733a145f497", withDelegate: nil)
    }
    func showVungle()
    {
        vungleSdk.playAd(self, error: nil)
    }
    
    func ShowAdmobBanner()
    {
        //bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        //}
        //self.view.bounds.height - 50
        bannerView = GADBannerView(frame: CGRectMake(0, 0 , 320, 50))
        bannerView?.adUnitID = "ca-app-pub-9535461294868148/2895273314"
        bannerView?.delegate = self
        bannerView?.rootViewController = self
        self.view.addSubview(bannerView!)
        //adViewHeight = bannerView!.frame.size.height
        bannerView?.loadRequest(GADRequest())
        bannerView?.hidden = true
    }
    func timerMethodAutoAd(timer:NSTimer) {
        println("auto play")
        adView.backgroundColor = UIColor.redColor()
        showAds()
        showAdcolony()
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adView.hidden = true
        
        let testFrame : CGRect = CGRectMake(0,0,320,200)
        var testView : UIView = UIView(frame: testFrame)
        testView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        testView.alpha=0.5
        self.view.addSubview(testView)
        
        
        //var myV = UIView(frame: CGRectMake(0, 20, 320, 350))
        //self.view.addSubview(myV)

        let skView = view as SKView//(frame: CGRectMake(0, 50, self.view.bounds.width, self.view.bounds.height))
       
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        
        
        //var size1 = CGSizeMake(self.view.bounds.width, self.view.bounds.height - 50 )
        let scene = GameScene(size: skView.bounds.size)
        
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
        
        self.interstitial = self.createAndLoadAd()
        
        //show chartboost
        Chartboost.showInterstitial("Level 1")
        //show vungle
        vungleSdk.delegate = self
        vungleSdk.playAd(self, error: nil)
        //adcolony
        showAdcolony()
        
        ShowAdmobBanner()
        
        showMobilecore2()
        
        
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //admob delegate
    //GADBannerViewDelegate
    func adViewDidReceiveAd(view: GADBannerView!) {
        println("adViewDidReceiveAd:\(view)");
        bannerView?.hidden = false
        
        //relayoutViews()
    }
    
    func adView(view: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        println("\(view) error:\(error)")
        bannerView?.hidden = false
        //relayoutViews()
    }
    
    func adViewWillPresentScreen(adView: GADBannerView!) {
        println("adViewWillPresentScreen:\(adView)")
        bannerView?.hidden = false
        
        //relayoutViews()
    }
    
    func adViewWillLeaveApplication(adView: GADBannerView!) {
        println("adViewWillLeaveApplication:\(adView)")
    }
    
    func adViewWillDismissScreen(adView: GADBannerView!) {
        println("adViewWillDismissScreen:\(adView)")
        
        // relayoutViews()
    }
}
