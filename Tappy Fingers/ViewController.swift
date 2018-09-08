//
//  ViewController.swift
//  Tappy Fingers
//
//  Created by ìÐąrκÐųçκ™ ☠ on 12/26/17.
//  Copyright © 2017 ìÐąrκÐųçκ™ ☠. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, GADBannerViewDelegate {

    @IBOutlet var label1: UILabel!
    @IBOutlet var label2: UILabel!
    
    @IBOutlet var tappyFingersIcon: UIImageView!
    
    @IBOutlet var button: UIButton!
    @IBOutlet var bannerView: GADBannerView!
    //app id ca-app-pub-6997426467599456~4631788503
    //ca-app-pub-6997426467599456/7491376826
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        label1.layer.cornerRadius = 5.0
        button.layer.cornerRadius = 5.0
        tappyFingersIcon.clipsToBounds = true;
        tappyFingersIcon.layer.cornerRadius = 90.0
        
        bannerView.isHidden = true
        
        //reference to two functions below
        bannerView.delegate = self
        //bannerView.adUnitID = "ca-app-pub-6997426467599456/7491376826"
        //test 2
        //bannerView.adUnitID = "ca-app-pub-6997426467599456/7305621400"
        //FOR DEBUG ONLY
        //bannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111"
        //
        
        //Removed for purchase code 6min 10sec
//        bannerView.adUnitID = "ca-app-pub-6997426467599456/7491376826"
//        bannerView.adSize = kGADAdSizeSmartBannerPortrait
//        bannerView.rootViewController = self
//        bannerView.load(GADRequest())
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.isHidden = false
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        bannerView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let userDefaults = Foundation.UserDefaults.standard
        //changed Key to record
        let value = userDefaults.string(forKey: "Record")
        //label2.text = value
        if(value == nil){
            label2.text = "0"
        }
        else{
            label2.text = value
        }
        
        let save = UserDefaults.standard
        if save.value(forKey: "Purchase") == nil {
            bannerView.adUnitID = "ca-app-pub-6997426467599456/7491376826"
            //bannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111"
            bannerView.adSize = kGADAdSizeSmartBannerPortrait
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        } else {
            bannerView.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

