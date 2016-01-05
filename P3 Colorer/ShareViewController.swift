//
//  ShareViewController.swift
//  P3 Colorer
//
//  Created by Monica Ong on 1/4/16.
//  Copyright © 2016 Monica Ong. All rights reserved.
//

import UIKit
import Social

class ShareViewController: UIViewController {
    
    var drawVC: UIViewController!
    var masterpiece: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let space = CGFloat(20)
        //set background image
        let backgroundImage = UIImage(named: "background")
        let backgroundImageView = UIImageView(frame: self.view.frame)
        backgroundImageView.image = backgroundImage
        backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.view.insertSubview(backgroundImageView, atIndex: 0)
        
        //show preview of masterpiece on screen
        let previewHeight = view.bounds.height*2/3
        let scaleFactor = previewHeight/masterpiece.size.height
        let previewWidth = masterpiece.size.width * scaleFactor
        let preview = UIImageView(frame: CGRectMake(0, 25, previewWidth, previewHeight))
        preview.center.x = view.bounds.width/2
        preview.image = masterpiece
        preview.contentMode = .ScaleAspectFit
        self.view.addSubview(preview)
        
        //create return button
        let buttonSize = ((view.bounds.height - preview.frame.maxY) - space*3)/2
        
        let returnButton = UIButton(frame: CGRectMake(0, 0, buttonSize, buttonSize))
        returnButton.setImage(UIImage(named: "returnIcon"), forState: .Normal)
        returnButton.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height - returnButton.bounds.height/2 - space)
        returnButton.addTarget(self, action: "returnDown:", forControlEvents: .TouchUpInside)
        self.view.addSubview(returnButton)
        
        //create save button
        let saveButton = UIButton(frame: CGRectMake(0, preview.frame.maxY + space, buttonSize, buttonSize))
        saveButton.setImage(UIImage(named: "saveIcon"), forState: .Normal)
        saveButton.setImage(UIImage(named: "doneIcon"), forState: .Disabled)
        saveButton.center.x = returnButton.center.x
        saveButton.addTarget(self, action: "save:", forControlEvents: .TouchUpInside)
        self.view.addSubview(saveButton)
        
        //create facebook button
        let centerX = view.bounds.width/6
        let facebookButton  = UIButton(frame: CGRectMake(saveButton.frame.minX - space - buttonSize, saveButton.frame.minY, buttonSize, buttonSize))
        facebookButton.setImage(UIImage(named: "facebookIcon"), forState: .Normal)
        facebookButton.addTarget(self, action: "postFacebook:", forControlEvents: .TouchUpInside)
        self.view.addSubview(facebookButton)
        
        //create twitter button
        let twitterButton  = UIButton(frame: CGRectMake(saveButton.frame.maxX + space, saveButton.frame.minY, buttonSize, buttonSize))
        twitterButton.setImage(UIImage(named: "twitterIcon"), forState: .Normal)
        twitterButton.addTarget(self, action: "postTwitter:", forControlEvents: .TouchUpInside)
        self.view.addSubview(twitterButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func postFacebook(sender: UIButton){
        var shareToFacebook : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        shareToFacebook.setInitialText("Checkout my masterpiece I made with Colorer!") //social framework does not allow this anymore :(
        shareToFacebook.addImage(masterpiece)
        self.presentViewController(shareToFacebook, animated: true, completion: nil)
    }
    
    func postTwitter(sender:  UIButton){
        var shareToTwitter : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        shareToTwitter.setInitialText("Checkout my masterpiece I made with Colorer!")
        shareToTwitter.addImage(masterpiece)
        self.presentViewController(shareToTwitter, animated: true, completion: nil)
    }
    
    func save(sender: UIButton){
        UIImageWriteToSavedPhotosAlbum(masterpiece, nil, nil, nil)
        sender.enabled = false
        self.performSelector("canSaveAgain:", withObject: sender, afterDelay: 1.0)
    }
    
    func canSaveAgain(sender: UIButton){
        sender.enabled = true
    }
    
    func returnDown(sender: UIButton){
        dismissViewControllerAnimated(true, completion: nil)
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
