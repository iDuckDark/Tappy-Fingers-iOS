//
//  EndViewController.swift
//  Tappy Fingers
//
//  Created by ìÐąrκÐųçκ™ ☠ on 12/26/17.
//  Copyright © 2017 ìÐąrκÐųçκ™ ☠. All rights reserved.
//

import UIKit
import Social
import MessageUI
import GoogleMobileAds

class EndViewController: UIViewController, GADBannerViewDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate{

    

    @IBOutlet var label1: UILabel!      //myscore
    @IBOutlet var label2: UILabel!      //share score
    
    @IBOutlet var button1: UIButton!    //twitter
    @IBOutlet var button2: UIButton!    //email
    @IBOutlet var button3: UIButton!    //sms
    @IBOutlet var button4: UIButton! //restart
    
    @IBOutlet var scoreLabel: UILabel!
    
    var scoreData : String!
    @IBOutlet var bannerView: GADBannerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label1.layer.cornerRadius = 5.0
        label2.layer.cornerRadius = 5.0
        button1.layer.cornerRadius = 5.0
        button2.layer.cornerRadius = 5.0
        button3.layer.cornerRadius = 5.0
        button4.layer.cornerRadius = 5.0
        scoreLabel.text = scoreData
    
        // Do any additional setup after loading the view.
        
        //ads
        bannerView.isHidden = true
        
        //reference to two functions below
        bannerView.delegate = self
//        bannerView.adUnitID = "ca-app-pub-6997426467599456/7491376826"
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
    @IBAction func restartGame(_ sender: Any) {
        //go back to the previous tapping screen
        self.dismiss(animated: false, completion: nil)
        self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func shareTwitter(_ sender: Any) {
        //if logged in
        if(SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter)){
            let twitter:SLComposeViewController = SLComposeViewController(forServiceType:SLServiceTypeTwitter)
            twitter.setInitialText("My final score was: \(scoreLabel.text!)")
            self.present(twitter, animated: true, completion: nil)
            
        }
        else{
            let alert = UIAlertController(title: "Account Not Logged In", message: "Please log in to your twitter account in Settings ", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK ", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert,animated: true,completion: nil)
        }
        
        
        
    }
    
    @IBAction func shareEmail(_ sender: Any) {
        if (MFMailComposeViewController.canSendMail()){
            let mail:MFMailComposeViewController =  MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(nil)
            mail.setSubject("I BET YOU CAN'T BEAT ME!!!")
            mail.setMessageBody("My final score was: \(scoreLabel.text!)", isHTML: false)
            self.present(mail, animated: true, completion: nil)
            
        }
        else{
            let alert = UIAlertController(title: "Accounts ", message: "Please log in to your own email account", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK ", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert,animated: true,completion: nil)
        }
    }
    //to dismiss the mail button
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareSMS(_ sender: Any) {
        if (MFMessageComposeViewController.canSendText()){
            let message:MFMessageComposeViewController =  MFMessageComposeViewController()
            message.messageComposeDelegate = self
            message.recipients = nil
            //message.subject = "I BET YOU CAN'T BEAT ME!!!"
            message.body = "My final score was: \(scoreLabel.text!)"
            self.present(message, animated: true, completion: nil)
            
        }
        else{
            let alert = UIAlertController(title: "WARNING ", message: "YOU ARE UNABLE TO SEND MESSAGE ON THIS DEVICE!!! ", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK ", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert,animated: true,completion: nil)
        }
        
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
