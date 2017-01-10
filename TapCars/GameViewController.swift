//
//  GameViewController.swift
//  TapCars
//
//  Created by Kishan Nakum on 15/12/16.
//  Copyright © 2016 kishan nakum. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds

class GameViewController: UIViewController,GADBannerViewDelegate {

    var adBannerView: GADBannerView!

    var interStital : GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "Menu") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        adBannerView = GADBannerView(frame:CGRect(x: 0, y: self.view.frame.size.height-60, width: self.view.frame.size.width, height: 60))
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        adBannerView.adUnitID = "ca-app-pub-7416735220963196/5019751467"
        
        let request = GADRequest()
        adBannerView.isHidden = true
//        request.testDevices = [kGADSimulatorID]
        adBannerView.load(request)
        self.view.addSubview(adBannerView)
        
        interStital = GADInterstitial(adUnitID:"ca-app-pub-7416735220963196/5981780660")
        let request2 = GADRequest()
        interStital.load(request2)
        interStital.present(fromRootViewController: self)
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        adBannerView.isHidden = false
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        adBannerView.isHidden = true
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
