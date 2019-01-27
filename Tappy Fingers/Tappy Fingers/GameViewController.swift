//
//  GameViewController.swift
//  Tappy Fingers
//
//  Created by ìÐąrκÐųçκ™ ☠ on 12/26/17.
//  Copyright © 2017 ìÐąrκÐųçκ™ ☠. All rights reserved.
//

import UIKit
import GoogleMobileAds

class GameViewController: UIViewController,GADBannerViewDelegate {

    @IBOutlet var label1: UILabel!
    @IBOutlet var label2: UILabel!
    
    @IBOutlet var button: UIButton!
    
    @IBOutlet var scoreLabel: UILabel!
    
    @IBOutlet var bannerView: GADBannerView!
    
    var tapInt = 0
    var startInt = 3
    var startTimer = Timer()
    
    //for countdown
    var gameInt = 10
    var gameTimer = Timer()
    
    var recordData : String!
    
    @IBOutlet var timeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        label1.clipsToBounds = true;
        label2.clipsToBounds = true;
        label1.layer.cornerRadius = 5.0
        label2.layer.cornerRadius = 5.0
        button.layer.cornerRadius = 5.0
        tapInt = 0
        
        scoreLabel.text = String(tapInt)
        startInt = 3
        button.setTitle(String(startInt), for: .normal)
        button.isEnabled = false
        
        
        startTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.startGameTimer), userInfo: nil, repeats: true)
       
        gameInt = 10
        timeLabel.text = String(gameInt)
        
        //for records
        let userDefaults = Foundation.UserDefaults.standard
        let value =  userDefaults.string(forKey: "Record")
        recordData = value
        
        //ads
        bannerView.isHidden = true
        
        //reference to two functions below
        bannerView.delegate = self
//        bannerView.adUnitID = "ca-app-pub-6997426467599456/7491376826"
//        //FOR DEBUG ONLY
//        //bannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111"
//        //
//        bannerView.adSize = kGADAdSizeSmartBannerPortrait
//        bannerView.rootViewController = self
//        bannerView.load(GADRequest())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let save = UserDefaults.standard
        if save.value(forKey: "Purchase") == nil {
            bannerView.adUnitID = "ca-app-pub-6997426467599456/7491376826"
            bannerView.adSize = kGADAdSizeSmartBannerPortrait
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        } else {
            bannerView.isHidden = true
        }
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.isHidden = false
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        bannerView.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapMeButton(_ sender: Any) {
        tapInt += 1
        scoreLabel.text = String(tapInt)
    }
    @objc func startGameTimer(){
        startInt -= 1
        button.setTitle(String(startInt), for: .normal)
        if(startInt==0){
            //prevent negative value
            startTimer.invalidate()
            //change button label
            button.setTitle("TAP ME", for: .normal)
            button.isEnabled = true
            //start game timer
            gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.game), userInfo: nil, repeats: true)
        }
    }
    @objc func game(){
        gameInt-=1
        timeLabel.text = String(gameInt)
        if(gameInt == 0){
            //prevent negative value
            gameTimer.invalidate()
            
            //records
            if (recordData == nil){
                let savedString = scoreLabel.text
                let userDefaults = Foundation.UserDefaults.standard
                userDefaults.set(savedString, forKey: "Record")
            }
            
            //=======
            //removed this>>>
            //save data
//            let savedString = scoreLabel.text
//            let userDefaults = Foundation.UserDefaults.standard
//            userDefaults.set(savedString, forKey: "Key")
        //=====================================================
            else{
                let score:Int? = Int(scoreLabel.text!)
                let record:Int? = Int(recordData)
                if(score! > record!){
                    let savedString = scoreLabel.text
                    let userDefaults = Foundation.UserDefaults.standard
                    userDefaults.set(savedString, forKey: "Record")
                }
            }
            
            button.setTitle("GAME OVER", for: .normal)
            button.isEnabled = false
            
            //end game
            Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(GameViewController.end), userInfo: nil, repeats: false)
        }
    }
    @objc func end(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "endGame") as! EndViewController
        vc.scoreData = scoreLabel.text
        self.present(vc, animated: false, completion: nil)
    }
}
