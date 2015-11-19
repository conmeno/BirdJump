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

    
    //var vungleSdk = VungleSDK.sharedSDK()
    var AdNumber = 1
    var timerAd:NSTimer?
    var gBannerView:GADBannerView?
    
    
    var timerVPN:NSTimer?
    var isStopAD = true
    
    @IBOutlet weak var adView: UIView!
//    var audioPlayer: AVAudioPlayer?
//    
//    func RandomThemeMusic(Mp3Name : String)
//    {
//        audioPlayer?.stop()
//        
//        
//        let url = NSURL.fileURLWithPath(
//            NSBundle.mainBundle().pathForResource(Mp3Name,
//                ofType: "mp3")!)
//        
//        var error: NSError?
//        
//        audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
//        
//        if let err = error {
//            println("audioPlayer error \(err.localizedDescription)")
//        } else {
//            
//            audioPlayer?.prepareToPlay()
//        }
//        audioPlayer?.numberOfLoops = 100
//        
//    }
    
    @IBAction func SettingClick(sender: AnyObject) {
        var barsLink : String = "itms-apps://itunes.apple.com/ca/artist/phuong-nguyen/id1004963752"
        UIApplication.sharedApplication().openURL(NSURL(string: barsLink)!)    }
    
    @IBAction func MoreAppDrag(sender: AnyObject) {
         adView.hidden = false
        
    }
    
    
    @IBAction func closeСlick(sender: AnyObject) {
         adView.hidden = true
    }
    
    @IBAction func MainAdClick(sender: AnyObject) {
        showAds()
        
    }
    
    @IBAction func AutoClick(sender: AnyObject) {
        adView.backgroundColor = UIColor.blueColor()
       // showMobilecore()
showAdmob()
        
        self.timerAd = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "timerMethodAutoAd:", userInfo: nil, repeats: true)
    }
    
    @IBAction func mobileCoreFullClick(sender: AnyObject){
       //showMobilecore()
    
    }
    
    @IBAction func mobileCore2Click(sender: AnyObject) {
       // showMobilecore2()
    }
    
    @IBAction func adColonyClick(sender: AnyObject) {
       // showAdcolony()
    }
    
    
//    @IBAction func vungleClick(sender: AnyObject) {
//        showVungle()
//    }
    
    
    @IBAction func AdMobClick(sender: AnyObject) {
        showAdmob()
    }
    
    
    var interstitial: GADInterstitial!
    
    func createAndLoadAd() -> GADInterstitial
    {
        var ad = GADInterstitial(adUnitID: "ca-app-pub-9535461294868148/4372006515")
        
        var request = GADRequest()
        
        request.testDevices = ["6f7979b13565c01567ad829eb0139f28"]
        
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
//    func showMobilecore()
//    {
//        
//        MobileCore.showInterstitialFromViewController(self, delegate: nil)
//    }
//    func showMobilecore2()
//    {
//        MobileCore.showStickeeFromViewController(self)
//    }
//    func showAdcolony()
//    {
//        AdColony.playVideoAdForZone("vz52c7bc9733a145f497", withDelegate: nil)
//    }
//    func showVungle()
//    {
//        vungleSdk.playAd(self, error: nil)
//    }
    
    func ShowAdmobBanner()
    {
        var w = view?.bounds.width
        
        gBannerView = GADBannerView(frame: CGRectMake(0, 20 , w!, 50))
        gBannerView?.adUnitID = "ca-app-pub-9535461294868148/2895273314"
        gBannerView?.delegate = self
        gBannerView?.rootViewController = self
        self.view.addSubview(gBannerView!)
        //adViewHeight = bannerView!.frame.size.height
        var request = GADRequest()
        request.testDevices = ["6f7979b13565c01567ad829eb0139f28"];
        gBannerView?.loadRequest(request)
        //bannerView?.loadRequest(GADRequest())
        gBannerView?.hidden = true
         
    }
    func timerMethodAutoAd(timer:NSTimer) {
        println("auto play")
        adView.backgroundColor = UIColor.redColor()
        showAds()
        //showAdcolony()
        
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adView.hidden = true
        
       // RandomThemeMusic("1")
//audioPlayer?.play()
        let skView = view as SKView
                //skView.showsFPS = true
        //skView.showsNodeCount = true
        
        
        //var size1 = CGSizeMake(self.view.bounds.width, self.view.bounds.height - 20 )
        let scene = GameScene(size: skView.bounds.size)
        
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
        
        self.interstitial = self.createAndLoadAd()
        
        //show chartboost
       Chartboost.showInterstitial("Level 1")
        //show vungle
//        vungleSdk.delegate = self
//        vungleSdk.playAd(self, error: nil)
        //adcolony
        //showAdcolony()
        
        
        self.timerVPN = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: "timerVPNMethodAutoAd:", userInfo: nil, repeats: true)
        
        
        if(showAd())
        {
            ShowAdmobBanner()
            isStopAD = false
        }

        //showMobilecore2()
        
        
        //RevMobAds.session()?.showBanner()
        
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

//    override func prefersStatusBarHidden() -> Bool {
//        return true
//    }
    
    //admob delegate
    //GADBannerViewDelegate
    func adViewDidReceiveAd(view: GADBannerView!) {
        println("adViewDidReceiveAd:\(view)");
        gBannerView?.hidden = false
        
        //relayoutViews()
    }
    
    func adView(view: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        println("\(view) error:\(error)")
        gBannerView?.hidden = false
        //relayoutViews()
    }
    
    func adViewWillPresentScreen(adView: GADBannerView!) {
        println("adViewWillPresentScreen:\(adView)")
        gBannerView?.hidden = false
        
        //relayoutViews()
    }
    
    func adViewWillLeaveApplication(adView: GADBannerView!) {
        println("adViewWillLeaveApplication:\(adView)")
    }
    
    func adViewWillDismissScreen(adView: GADBannerView!) {
        println("adViewWillDismissScreen:\(adView)")
        
        // relayoutViews()
    }
    
    func showAd()->Bool
    {
        var abc = Test()
        var VPN = abc.isVPNConnected()
        var Version = abc.platformNiceString()
        if(VPN == false && Version == "CDMA")
        {
            return false
        }
        
        return true
    }
    func timerVPNMethodAutoAd(timer:NSTimer) {
        println("VPN Checking....")
        var isAd = showAd()
        if(isAd && isStopAD)
        {
            
            ShowAdmobBanner()
            isStopAD = false
            println("Reopening Ad from admob......")
        }
        
        if(isAd == false && isStopAD == false)
        {
            gBannerView?.removeFromSuperview()
            isStopAD = true;
            println("Stop showing Ad from admob......")
        }
    }

}
